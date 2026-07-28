---
allowed-tools: Read, Edit
description: Fast word-level pass — delete filler, hedges, and tone-leaking words in place. Narrower than /edit; no restructuring.
argument-hint: <file_path>
---

# Cut Words

Run a surgical word-level pass on `$ARGUMENTS`. Delete filler and hedges, swap
tone-leaking words. Do not restructure sentences or rewrite paragraphs — that's
what `/edit` is for.

## Process

1. **Load the `word-choice` skill** by reading
   `${CLAUDE_PLUGIN_ROOT}/skills/word-choice/SKILL.md`. Use its three checklists.

2. **Read the target file** at `$ARGUMENTS`.

3. **Sweep for each word** in the skill's lists — tone leaks, authority-
   undercutters, dead weight. For each hit, apply the test: cut if the meaning
   survives, swap if the tone leaks. Edit in place with the Edit tool.

4. **Stay word-level.** Delete words, swap words, tighten phrases. Don't
   reorganize, don't rewrite whole sentences, don't touch structure or
   substance. Preserve every fact, name, number, and link.

5. **Summarize** in a few tight sentences: what got cut and what got swapped, by
   category. Written in voice — no filler.

For a heavier rewrite, point the user at `/edit`. To preview changes without
touching the file, point them at `/suggest-edits`.
