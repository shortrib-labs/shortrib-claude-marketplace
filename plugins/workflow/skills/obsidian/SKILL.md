---
name: obsidian
description: Interact with Obsidian vaults using the Obsidian CLI. Read, search, create, and modify notes, manage properties/tags, query tasks, work with daily notes, and run Obsidian commands. Use when the user asks to work with their Obsidian vault, notes, or knowledge base.
allowed-tools: Bash
---

# Obsidian CLI Skill

Interact with Obsidian vaults through the `obsidian` command-line interface.

## General Syntax

```bash
obsidian <command> [options]
```

- `vault=<name>` targets a specific vault when multiple are open.
- File resolution: `file=<name>` resolves like wikilinks; `path=<path>` is an exact path (e.g., `folder/note.md`).
- Most commands default to the active file when `file`/`path` is omitted.
- Quote values with spaces: `name="My Note"`.
- Use `\n` for newline, `\t` for tab in content values.

## Reading and Writing Notes

### Read a note
```bash
obsidian read file="Note Name"
obsidian read path="folder/note.md"
```

### Create a note
```bash
obsidian create name="New Note" content="# Heading\nBody text"
obsidian create path="folder/note.md" template="My Template" open
```
Options: `overwrite`, `open`, `newtab`.

### Append to a note
```bash
obsidian append file="Note Name" content="New paragraph"
obsidian append path="folder/note.md" content="Inline addition" inline
```
`inline` appends without a preceding newline.

### Prepend to a note
```bash
obsidian prepend file="Note Name" content="Added to top"
```

### Move or rename
```bash
obsidian move file="Old Name" to="new/folder/"
obsidian rename file="Old Name" name="New Name"
```

### Delete
```bash
obsidian delete file="Note Name"
obsidian delete path="folder/note.md" permanent
```
Without `permanent`, files go to trash.

## Daily Notes

```bash
obsidian daily                                    # Open today's daily note
obsidian daily:read                               # Read daily note contents
obsidian daily:path                               # Get daily note file path
obsidian daily:append content="- Task done"       # Append to daily note
obsidian daily:prepend content="## Morning"       # Prepend to daily note
```

Append/prepend accept `open` and `inline` options.

## Search

### Text search
```bash
obsidian search query="search term"
obsidian search query="search term" path="subfolder" limit=10 case
```

### Search with context (shows matching lines)
```bash
obsidian search:context query="search term" format=json
```

### Open search in Obsidian UI
```bash
obsidian search:open query="search term"
```

Output formats: `text` (default), `json`.

## Properties (Frontmatter)

### Read a property
```bash
obsidian property:read name="status" file="Note Name"
```

### Set a property
```bash
obsidian property:set name="status" value="done" file="Note Name"
obsidian property:set name="rating" value="5" type=number file="Note Name"
```
Types: `text`, `list`, `number`, `checkbox`, `date`, `datetime`.

### Remove a property
```bash
obsidian property:remove name="status" file="Note Name"
```

### List properties in vault
```bash
obsidian properties                          # All properties in vault
obsidian properties file="Note Name"         # Properties for one file
obsidian properties counts sort=count        # Sorted by frequency
obsidian properties format=json
```

## Tags

```bash
obsidian tags                                # All tags in vault
obsidian tags counts sort=count              # Sorted by frequency
obsidian tags file="Note Name"               # Tags for one file
obsidian tag name="project" verbose          # Tag details with file list
obsidian tags format=json
```

## Tasks

### List tasks
```bash
obsidian tasks                               # All tasks in vault
obsidian tasks todo                          # Incomplete tasks only
obsidian tasks done                          # Completed tasks only
obsidian tasks file="Note Name"              # Tasks from one file
obsidian tasks daily                         # Tasks from daily note
obsidian tasks active                        # Tasks from active file
obsidian tasks verbose                       # Grouped by file with line numbers
obsidian tasks format=json
```

### Update a task
```bash
obsidian task path="folder/note.md" line=15 done     # Mark complete
obsidian task path="folder/note.md" line=15 todo     # Mark incomplete
obsidian task path="folder/note.md" line=15 toggle   # Toggle status
obsidian task daily line=8 done                       # Complete task in daily note
obsidian task ref="folder/note.md:15" toggle         # Using ref shorthand
```

## Files and Folders

### List files
```bash
obsidian files                               # All files
obsidian files folder="subfolder"            # In specific folder
obsidian files ext=md                        # By extension
obsidian files total                         # Count only
```

### File info
```bash
obsidian file file="Note Name"
obsidian file path="folder/note.md"
```

### List folders
```bash
obsidian folders
obsidian folders folder="parent" total
```

### Open a file
```bash
obsidian open file="Note Name"
obsidian open file="Note Name" newtab
```

## Links and Graph

### Outgoing links from a file
```bash
obsidian links file="Note Name"
obsidian links file="Note Name" total
```

### Backlinks to a file
```bash
obsidian backlinks file="Note Name"
obsidian backlinks file="Note Name" counts format=json
```

### Orphans and dead ends
```bash
obsidian orphans                             # Files with no incoming links
obsidian deadends                            # Files with no outgoing links
obsidian unresolved                          # Broken links in vault
obsidian unresolved counts verbose format=json
```

## Bookmarks

```bash
obsidian bookmarks                           # List bookmarks
obsidian bookmark file="note.md"             # Bookmark a file
obsidian bookmark file="note.md" subpath="#heading"  # Bookmark a heading
obsidian bookmark search="query" title="Saved Search"
obsidian bookmark url="https://example.com" title="Link"
```

## Templates

```bash
obsidian templates                           # List available templates
obsidian template:read name="My Template"    # Read template content
obsidian template:read name="My Template" resolve title="New Note"  # With variables resolved
obsidian template:insert name="My Template"  # Insert into active file
```

## Outline (Headings)

```bash
obsidian outline                             # Headings of active file
obsidian outline file="Note Name"
obsidian outline format=tree                 # Tree view (default)
obsidian outline format=md                   # Markdown
obsidian outline format=json                 # JSON
```

## Aliases

```bash
obsidian aliases                             # All aliases in vault
obsidian aliases file="Note Name"            # Aliases for one file
obsidian aliases verbose                     # Include file paths
```

## Vault Info

```bash
obsidian vault                               # Vault name, path, stats
obsidian vault info=name                     # Just the name
obsidian vault info=path                     # Just the path
obsidian vaults                              # List all known vaults
obsidian vaults verbose                      # With paths
```

## Plugins

```bash
obsidian plugins                             # List installed plugins
obsidian plugins filter=community versions   # Community plugins with versions
obsidian plugins:enabled                     # Only enabled plugins
obsidian plugin id="plugin-id"               # Plugin details
obsidian plugin:enable id="plugin-id"
obsidian plugin:disable id="plugin-id"
obsidian plugin:install id="plugin-id" enable
obsidian plugin:uninstall id="plugin-id"
```

## Commands and Hotkeys

### Execute a command
```bash
obsidian command id="editor:toggle-bold"
obsidian commands                            # List all commands
obsidian commands filter="editor"            # Filter by prefix
```

### Hotkeys
```bash
obsidian hotkeys                             # List all hotkeys
obsidian hotkey id="editor:toggle-bold"      # Hotkey for specific command
```

## Bases (Database Views)

```bash
obsidian bases                               # List all base files
obsidian base:views                          # List views in current base
obsidian base:query file="My Base" format=json
obsidian base:query file="My Base" view="Active" format=md
obsidian base:create file="My Base" name="New Entry" content="Details"
```

Output formats: `json` (default), `csv`, `tsv`, `md`, `paths`.

## Sync

```bash
obsidian sync:status                         # Check sync status
obsidian sync on                             # Resume sync
obsidian sync off                            # Pause sync
obsidian sync:deleted                        # Files deleted in sync
obsidian sync:history file="Note Name"       # Sync versions
obsidian sync:read file="Note Name" version=1
obsidian sync:restore file="Note Name" version=1
```

## File History (Local)

```bash
obsidian history:list                        # Files with history
obsidian history file="Note Name"            # List versions
obsidian history:read file="Note Name" version=1
obsidian history:restore file="Note Name" version=1
```

## Diff (Local and Sync Versions)

```bash
obsidian diff file="Note Name"               # List versions
obsidian diff file="Note Name" from=1 to=2   # Diff between versions
obsidian diff file="Note Name" filter=local   # Only local versions
obsidian diff file="Note Name" filter=sync    # Only sync versions
```

## Other Utilities

```bash
obsidian recents                             # Recently opened files
obsidian random                              # Open random note
obsidian random:read                         # Read random note
obsidian wordcount file="Note Name"          # Word and character count
obsidian wordcount file="Note Name" words    # Word count only
obsidian tabs                                # List open tabs
obsidian workspace                           # Show workspace tree
obsidian reload                              # Reload vault
```

## Themes and Snippets

```bash
obsidian themes                              # List installed themes
obsidian theme                               # Active theme
obsidian theme:set name="Minimal"
obsidian theme:install name="Minimal" enable
obsidian snippets                            # List CSS snippets
obsidian snippet:enable name="my-snippet"
obsidian snippet:disable name="my-snippet"
```

## Output Formats

Many commands support `format=json|tsv|csv` (and sometimes `md`, `yaml`, `text`).

**Recommendation**: Use `format=json` when processing data programmatically.

## Notes

- Obsidian must be running for the CLI to work.
- The CLI communicates with the running Obsidian instance.
- `file=<name>` resolves like wikilinks (by display name); `path=<path>` uses the exact vault-relative path.
- Commands that modify files (append, prepend, create, delete, move, rename, property:set) change the actual vault files.
- Use `obsidian daily:read` and `obsidian daily:append` for daily-note workflows instead of direct file operations, so the path is resolved automatically.
