---
name: inbox-process
description: >
  Scan, classify, enrich, and file Obsidian notes from Inbox/ and the vault root
  into the PARA folder structure. Use when the user wants to process their inbox,
  triage notes, or organize unfiled content. Triggers on "process inbox",
  "triage notes", "file inbox", "organize notes", "clean up inbox".
argument-hint: "[--dry-run] [--batch-size N]"
disable-model-invocation: true
allowed-tools: Bash(obsidian *), Bash(mkdir *), Bash(mv *), Bash(kill -0 *), Read, Glob, Grep
---

# Inbox Process

Scan, classify, and file Obsidian notes from Inbox/ and the vault root into the PARA folder structure. Every note move goes through the Obsidian CLI to preserve wiki-links.

## Arguments

Parse `$ARGUMENTS` for:
- `--dry-run`: Classify and report without moving anything. Print what would happen.
- `--batch-size N`: Maximum notes to process per run. Default: 25.

## Prerequisites

Before doing anything else:

1. **Check Obsidian is running.** Run `obsidian vault`. If it returns non-zero, stop immediately and report: "Obsidian is not running. Start Obsidian and try again." Do not attempt to launch Obsidian.

2. **Load the Obsidian CLI reference.** Read `${CLAUDE_PLUGIN_ROOT}/skills/obsidian/SKILL.md` for command syntax. Use `path=` (not `file=`) for all CLI operations to get deterministic path resolution.

3. **Load reference files.** Read both files from the skill directory:
   - `${CLAUDE_PLUGIN_ROOT}/skills/inbox-process/classification-rules.md`
   - `${CLAUDE_PLUGIN_ROOT}/skills/inbox-process/frontmatter-schema.md`

## Phase 1: Gather Context

Build a complete picture of the vault before processing any notes.

### 1.1 Scan Vault Structure

Run `obsidian folders` to get the full folder tree. Identify:
- All PARA folders and their subfolders (Projects/*, Areas/*, Resources/*, Archive/*)
- Pre-PARA folders that are excluded from processing (Daily/, Readwise/, Books/, Templates/, Replicated/, Excalidraw/)

### 1.2 Read PARA Design

Find and read the PARA Design document. It may be at `Inbox/PARA Design.md` or already filed elsewhere. Search with `obsidian search query="PARA System Design" limit=3` if not at the expected path.

Extract from the PARA Design doc:
- Current project list and their folder names
- Area list (work and personal) and their folder names
- Resource categories and their folder names
- Tag taxonomy (topic tags, entity tags, workflow tags)

### 1.3 Enumerate Notes to Process

Collect all notes in scope:

1. Run `obsidian files folder="Inbox" ext=md` to list Inbox notes.
2. Run `ls /Users/chuck/workspace/vaults/Notes/*.md 2>/dev/null` to list vault root markdown files (the CLI may not reliably enumerate root files).

**Exclude from processing:**
- `PARA Design.md` and `PARA Operating Manual.md` (reference docs, skip)
- `favorite.md` and any Obsidian system files at vault root
- Any file that is not a `.md` file

Sort the combined list alphabetically by filename for deterministic processing order. Trim to `--batch-size` limit.

Report: "Found N notes to process (M in Inbox, K at vault root). Batch size: B."

## Phase 2: Classify and Execute

Process each note one at a time in alphabetical order. For each note:

### 2.1 Read the Note

Read the note's full content with `obsidian read path="<vault-relative-path>"`. Parse:
- Existing frontmatter (all fields)
- Body content
- Wiki-links via `obsidian links path="<vault-relative-path>"`
- Embedded attachments: scan for `![[filename]]` patterns in the body

### 2.2 Classify Destination

Using the classification rules (loaded in Phase 1), determine the best PARA destination folder.

**Your classification judgment should weigh:**
- Where do this note's wiki-link targets live in the vault? (strongest signal)
- What do existing frontmatter fields suggest? (`type`, `tags`, `related`)
- Does the filename match a known pattern? (date-prefixed meeting notes)
- What does the body content reveal about the note's purpose?

**Apply PARA priority:** Projects > Areas > Resources.

**If no existing subfolder is a confident match:**
- Check how many new folders have already been created this run.
- If under the cap (3), create a new subfolder with `mkdir -p`.
- If at the cap, skip this note and log "needs manual filing."

**If the note is empty or has only frontmatter with no content:** Skip and log "empty, needs manual review."

**If classification is truly ambiguous:** Skip and log "needs manual filing" with a brief explanation of the ambiguity.

### 2.3 Normalize Frontmatter

Apply the frontmatter schema (loaded in Phase 1):

1. **Ensure all canonical fields exist.** For each missing canonical field, set it:
   - `date`: Use existing value, or file creation date, or today
   - `type`: Infer from content analysis (meeting, brief, research, etc.)
   - `tags`: Start with existing tags, add tags from PARA taxonomy that match content
   - `last_updated`: Set to today (YYYY-MM-DD)
   - `status`: Use default status for the inferred type (see schema)
   - `aliases`: Only add if there's an obvious abbreviation or short name

2. **Merge, don't overwrite.** If a field already has a value:
   - For `tags`: Append new tags to existing list, deduplicate
   - For `type`/`status`: If the existing value matches the controlled vocabulary, keep it. If unrecognized, preserve and log a warning.
   - For `date`: Preserve the existing format (don't fight the Obsidian Linter)

3. **Rename known synonyms.** If `link` field exists, rename to `url` using the three-step process: read, set new, remove old.

4. **Preserve non-canonical fields.** Never remove fields you don't recognize.

Use `obsidian property:set` for each field that needs setting. Use `path=` for deterministic resolution.

For list-type fields (tags, aliases), use `type=list` with `obsidian property:set`. If append behavior is uncertain, read the current value first, merge in memory, then write the complete list.

### 2.4 Move the Note

**In dry-run mode:** Print the proposed move and skip to the next note.
```
[DRY RUN] Would move: "Note Title" -> Projects/Salesforce to Attio Migration/ (type: meeting, tags: [attio, sync])
```

**In normal mode:**

1. If the destination subfolder doesn't exist, create it: `mkdir -p "<vault-path>/<destination>/"`
2. Move the note: `obsidian move path="<current-path>" to="<destination-folder>/"`
3. If the note has embedded attachments (`![[image.png]]` patterns):
   a. Resolve each attachment's current location (check `Inbox/attachments/`, `Inbox/`, or relative to the note)
   b. Validate the resolved path is within the vault boundary (reject any path containing `..` that escapes the vault)
   c. Check if the attachment is referenced by other notes (search for `![[filename]]` across the vault)
   d. If shared by multiple notes going to different destinations, leave in place and log "shared attachment, left in place"
   e. If not shared: `mkdir -p "<destination>/attachments/"` then `mv "<source>" "<destination>/attachments/"`
4. Log the result

**Error handling:** If any step fails for a note, log the error and continue to the next note. Do not abort the run.

### 2.5 Log the Result

Track each processed note for the Phase 3 report:
- Note filename
- Source location (Inbox/ or vault root)
- Destination folder
- Inferred type
- Whether a new folder was created
- Any warnings (unrecognized vocabulary, shared attachments, etc.)

## Phase 3: Report

### 3.1 Terminal Summary

Print a summary to the terminal:

```
## Inbox Processing Complete

Processed: N | Skipped: M | Errors: E | New folders: F

### Moved
| Note | From | To | Type |
|------|------|----|------|
| Note Title | Inbox/ | Projects/Attio Migration/ | meeting |
| ...

### Skipped (if any)
| Note | Reason |
|------|--------|
| Empty Note | empty, needs manual review |
| ...

### Warnings (if any)
- Note X has unrecognized type 'foo', preserved as-is
- Shared attachment image.png left in place (referenced by Note A and Note B)

### New Folders Created (if any)
- Resources/New Topic/
```

In dry-run mode, prefix the summary with `[DRY RUN] No changes were made.` and show the "Would move" table instead.

### 3.2 Append to Log File

**Skip this step in dry-run mode.**

Append results to `~/.local/share/inbox-process/logs/YYYY-MM.md` (using the current year-month).

Create the directory if it doesn't exist: `mkdir -p ~/.local/share/inbox-process/logs/`

If the log file doesn't exist yet, create it with a top-level heading: `# Inbox Processing Log - YYYY-MM`

Append a run entry:

```markdown
## YYYY-MM-DD HH:MM

| Note | From | To | Type | New Folder |
|------|------|----|------|------------|
| Note Title | Inbox/ | Projects/Attio Migration/ | meeting | |
| Other Note | Inbox/ | Resources/New Topic/ | concept | yes |

Processed: N | Skipped: M | Errors: E | New folders: F
```

### 3.3 Vault Reindex

After all moves are complete (not in dry-run mode), run `obsidian reload` to trigger vault reindexing. This ensures Obsidian picks up all the file moves and new folders.

## Error Handling

- **Single note failure:** Log the error, skip the note, continue processing. Report in the summary.
- **Obsidian CLI not responding:** If a CLI command hangs or returns unexpected errors mid-run, attempt one retry. If it fails again, stop processing and report what was completed.
- **Multiple notes failing for the same reason:** After 3 consecutive failures, pause and investigate whether the root cause affects all remaining notes. Report findings.
- **Path traversal defense:** Before any file operation, validate that resolved paths are within the vault boundary (`/Users/chuck/workspace/vaults/Notes/`). Reject any path containing `..` segments that would escape the vault.
