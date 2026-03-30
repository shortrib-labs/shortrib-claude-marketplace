# Classification Rules

Reference for the inbox-process skill. Read this file during Phase 1 (context gathering) to inform classification decisions.

## Signal Priority

When classifying a note, consider these signals in roughly this order:

1. **Wiki-link targets** (strongest signal). If a note links to items that live in a specific PARA subfolder, that subfolder is the likely destination. Count link matches per subfolder.
2. **Frontmatter fields**. Existing `type`, `tags`, and `related` fields are direct hints. A note with `type: meeting` and `tags: [attio]` likely belongs in the Attio project folder.
3. **Filename patterns**. Date-prefixed notes containing meeting keywords (sync, standup, 1:1, prep, retro, review, check-in, kickoff, all-hands) are meetings. Date-prefixed notes without meeting keywords need content analysis.
4. **Content analysis**. Read the body text. Topic keywords, headings, and structure reveal the note's purpose. Meeting notes have attendee lists and action items. Research notes have citations and analysis. Briefs have recommendations and next steps.

## PARA Category Priority

When multiple PARA categories could fit, prefer in this order:

1. **Projects** (active, time-bound work with a deadline or deliverable)
2. **Areas** (ongoing responsibilities maintained indefinitely)
3. **Resources** (reference material for future use)

This follows PARA Operating Manual rule 7: "when in doubt, put it in the Area."

## Tiebreaking

When a note has signals pointing to multiple destinations:

1. Prefer the subfolder with the most wiki-link matches.
2. If tied on links, apply PARA category priority (Projects > Areas > Resources).
3. If still ambiguous, choose the destination that is most specific. A note about an Attio migration meeting goes to `Projects/Salesforce to Attio Migration/`, not `Areas/Sales Operations/`.

**Example:** A note links to both `[[Attio]]` (which lives in Projects/) and `[[Sales Operations]]` (which lives in Areas/). File to Projects/ because project links take priority.

## Subfolder Selection

Match notes to **existing** subfolders first. Only create a new subfolder when no existing folder is a confident match.

**New subfolder rules:**
- Use Title Case with spaces, matching existing convention ("AI & Agents", "Family & Home", "Sales & GTM").
- Cap at **3 new folders per run**. Notes that would require a 4th new folder are logged as "needs manual filing" and skipped.
- New folders are created via `mkdir -p` (no Obsidian CLI command for folder creation).

## Scope

**Process these locations:**
- All `.md` files in `Inbox/`
- All `.md` files directly at the vault root (not in subdirectories)

**Exclude from processing:**
- Files already in PARA folders (Projects/, Areas/, Resources/, Archive/)
- Files in pre-PARA folders (Daily/, Readwise/, Books/, Templates/, Replicated/, Excalidraw/)
- `favorite.md` and Obsidian system files at vault root
- The PARA Design and PARA Operating Manual documents themselves (they are reference docs that stay in place until manually moved)

## Special Cases

- **Replicated-related notes:** File new Replicated notes into PARA folders, not the legacy `Replicated/` hierarchy. New notes follow the new system.
- **Tag-only resource topics** (e.g., "Obsidian & PKM", "Travel"): These have no dedicated Resource subfolder. File to the most relevant Area and apply the topic tag.
- **Empty notes or notes with only frontmatter:** Skip and log as "empty, needs manual review."
- **Notes with ambiguous content that defies classification:** Skip and log as "needs manual filing."
