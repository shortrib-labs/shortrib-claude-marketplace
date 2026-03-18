---
allowed-tools: Read, Edit
description: Rewrite text applying the taste skill's editorial standards. Replaces /de-ai-ify with richer, taste-aware editing.
argument-hint: <file_path>
---

# Edit in Voice

Rewrite the file at `$ARGUMENTS` in place, applying the voice skill.

## Process

1. **Load the taste skill** by reading `${CLAUDE_PLUGIN_ROOT}/skills/taste/SKILL.md`. This contains the full taste profile and all style rules. Internalize it before touching the file.

2. **Read the target file** at `$ARGUMENTS`. Understand what it's saying — the substance, the argument, the specifics.

3. **Edit in place.** No "-HUMAN" copy. Git handles versioning. Use the Edit tool to make changes directly in the file.

4. **Apply every rule from the taste skill:**
   - Kill everything in the "What to Kill" section. Don't replace with synonyms — restructure or cut.
   - Enforce sentence-level rules: no adverbs, light adjectives, varied length, direct statements, specifics over generalities.
   - Enforce paragraph-level rules: no bullets in narrative, no emoji, engaging openings, tight.
   - Match the context-specific adaptation that fits (professional narrative, strategy doc, Slack, creative).
   - Preserve everything in the "What to Preserve" section: substance, the writer's point, technical accuracy, links.

5. **Show a tight summary of what changed.** Not a line-by-line diff — a few sentences describing the nature of the edits. What got cut, what got tightened, what got restructured. Written in the same voice.
