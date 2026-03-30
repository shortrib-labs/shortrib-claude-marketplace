---
description: Process Obsidian inbox notes into PARA folder structure
argument-hint: "[--dry-run] [--batch-size N]"
disable-model-invocation: true
---

# Inbox Process

Process unfiled notes from the Obsidian inbox.

## Process

1. **Load the inbox-process skill** by reading `${CLAUDE_PLUGIN_ROOT}/skills/inbox-process/SKILL.md`. Follow its process.

2. **Parse arguments** from `$ARGUMENTS`:
   - `--dry-run`: Pass through to the skill. Classify and report without moving.
   - `--batch-size N`: Pass through to the skill. Default: 25.

3. **Follow the skill's full process**: gather context, classify and execute per-note, report results.
