# Frontmatter Schema

Reference for the inbox-process skill. Defines the canonical frontmatter fields, controlled vocabularies, and field handling rules.

## Canonical Fields

Every processed note must have these fields after processing:

| Field | Format | Required | Notes |
|-------|--------|----------|-------|
| `date` | Preserve existing format | Yes | Don't fight the Obsidian Linter's date format. If missing, use file creation date or today. |
| `type` | Controlled vocabulary (see below) | Yes | Inferred from content if not present. |
| `tags` | YAML list | Yes | Flat tags from PARA Design taxonomy. Can be empty list. |
| `last_updated` | ISO 8601 (YYYY-MM-DD) | Yes | Set to today's date on processing. |
| `status` | Controlled vocabulary (see below) | Yes | Set based on type if not present. |
| `aliases` | YAML list | When applicable | Abbreviations, informal names, shortened titles. Only add when obvious. |

## Type Vocabulary

Flat list, no hierarchy:

- `meeting` - Meeting notes, syncs, 1:1s, all-hands, retros, kickoffs
- `brief` - Decision documents, proposals, recommendations
- `research` - Analysis, investigation, deep-dives
- `concept` - Ideas, explorations, thought pieces
- `session-transcript` - AI session logs, Claude transcripts
- `strategy` - Strategic plans, roadmaps, vision documents
- `vendor-profile` - Vendor assessments, product evaluations
- `case-study` - Customer stories, implementation examples
- `idea` - Quick captures, seeds for future work
- `reference` - How-to guides, cheat sheets, documentation

Meeting subtypes (1:1, sync, all-hands, retro, kickoff, customer-call, direct-report) are expressed as **tags**, not as type values.

## Status Vocabulary

Tight lifecycle:

- `draft` - Work in progress, not yet actionable
- `active` - Current, relevant, actionable
- `waiting` - Blocked on someone or something
- `complete` - Finished, outcome achieved
- `archived` - No longer relevant, kept for reference

### Default Status by Type

When a note has no existing `status` field:

| Type | Default Status |
|------|---------------|
| meeting | `active` |
| brief | `active` |
| strategy | `active` |
| vendor-profile | `active` |
| case-study | `active` |
| idea | `draft` |
| concept | `draft` |
| research | `draft` |
| session-transcript | `complete` |
| reference | `active` |

## Tag Taxonomy

Tags are read from the PARA Design doc at runtime. Do not hardcode them here. The PARA Design doc defines three tag categories:

- **Topic tags** - Subject matter (#cooking, #ai, #sales, etc.)
- **Entity tags** - People, pets, tools, companies (#leo, #shelley, #replicated, etc.)
- **Workflow tags** - Status/process (#review, #waiting, #someday)

Apply tags that match the note's content. Use existing tags from the taxonomy. Do not invent new tags unless the note clearly covers a topic not represented in the taxonomy.

Meeting characteristics are expressed as tags: `1:1`, `sync`, `direct-report`, `customer-call`, `all-hands`, `retro`, `kickoff`, `standup`, `prep`.

## Field Handling Rules

### Preserving Existing Fields

- **Non-canonical fields** (e.g., `researcher`, `git_commit`, `branch`, `source`, `transcript`, `related`): Preserve as-is. Never remove or rename fields you don't recognize.
- **Existing canonical fields with values:** Merge, don't overwrite. If a note already has `tags: [ai, sales]`, add new tags to the list rather than replacing.
- **`title` field:** Preserve if present. The Obsidian Linter manages this field.
- **`aliases` field:** Preserve existing aliases. Only append new obvious ones.

### Synonym Mapping

Known synonyms that should be renamed to canonical form:

| Found | Rename To | Notes |
|-------|-----------|-------|
| `link` | `url` | Different semantic meaning from wiki-links |

The Obsidian Linter manages a `last updated` field (with a space). Leave it alone. The skill's canonical field is `last_updated` (with an underscore). Both can coexist.

### Renaming Process

Renaming a frontmatter field via Obsidian CLI requires three steps:

1. `obsidian property:read name="old_name" path="..."` - Read the current value
2. `obsidian property:set name="new_name" value="..." path="..."` - Set the new field
3. `obsidian property:remove name="old_name" path="..."` - Remove the old field

### Unrecognized Vocabulary Values

When existing `type` or `status` values don't match the controlled vocabulary:

- **Preserve the original value.** Do not silently overwrite.
- **Log a warning:** "Note X has unrecognized type/status 'Y', preserved as-is."
- The user can review and correct these manually.
