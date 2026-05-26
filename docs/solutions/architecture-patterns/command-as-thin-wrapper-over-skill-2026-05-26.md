---
title: Plugin Command Files Should Be Thin Wrappers Over Skills
date: 2026-05-26
category: docs/solutions/architecture-patterns/
module: shortrib-claude-marketplace
problem_type: architecture_pattern
component: tooling
severity: medium
applies_when:
  - Adding a command file for a workflow that also has a companion skill file
  - An existing command file contains process steps that duplicate the companion skill
tags:
  - plugin-authoring
  - command-skill-relationship
  - thin-wrapper
  - single-source-of-truth
  - dry-principle
---

# Plugin Command Files Should Be Thin Wrappers Over Skills

## Context

Claude Code plugins have two distinct surfaces: commands (slash-command invocation, e.g. `/workshop`) and skills (loadable context blocks, e.g. `Load the workshop skill`). Both can describe the same workflow. When they do, the temptation is to write the process steps once in the command file and copy them into the skill, or vice versa.

This was the original structure of `/workshop`: the command file (`commands/workshop.md`) contained 45 lines of full process instructions, and the companion skill file (`skills/workshop/SKILL.md`) contained the same five sections almost word-for-word. A code review on `feature/crdant/augments-writing-skills` flagged the duplication as a P1 maintainability finding: when the workflow logic changes, both files must be updated identically with no mechanical enforcement. They will eventually drift.

The fix resolved the duplication by making the command a thin wrapper — a 9-line file that delegates entirely to the skill. The skill became the single authoritative source.

## Guidance

When a command and skill describe the same workflow, the command file should contain only:

1. Frontmatter (`allowed-tools`, `description`, `argument-hint`)
2. A title
3. One delegation line: `Load the <skill-name> skill. Work through the draft at $ARGUMENTS.`

```markdown
---
allowed-tools: Read, Edit
description: [Trigger description — when to use this command vs. related commands]
argument-hint: <file_path>
---

# Command Name

Load the `skill-name` skill. [Handle $ARGUMENTS.]
```

The skill file holds all process content: step-by-step instructions, maturity frameworks, referenced sub-skills, summary format, and any context-sensitive branching. The command file provides the slash-command surface that invokes the skill; the skill provides the behavior.

The only content that belongs exclusively in the command file is the argument-handling step — receiving `$ARGUMENTS` and passing the file path into the workflow — since the skill file has no `$ARGUMENTS` context at load time.

## Why This Matters

Full process duplication creates a two-file sync obligation with no enforcement mechanism. Neither file names the other as its counterpart. A developer modifying the workflow six months later reads one file, updates it, and unknowingly leaves the other stale. The two descriptions diverge silently — the command runs one workflow, the skill runs another.

The thin-wrapper pattern eliminates the sync obligation by design: there is one authoritative description. Updating the skill updates the command. Reading the command tells you immediately where the behavior lives.

## When to Apply

- **New command with companion skill**: write the thin wrapper from the start. Don't duplicate.
- **Existing command with duplicate prose**: reduce the command to a thin wrapper, promote all process content to the skill.
- **Retroactive candidates in this repo**: `commands/edit.md` and `commands/community-post.md` may have companion skills worth auditing for duplication.
- **Exception**: if a command genuinely has no companion skill (pure argument-handling with no shared behavior), the thin-wrapper pattern does not apply — there is nothing to delegate to.

## Examples

**Before: command with full process prose (45 lines, duplicating the skill):**

```markdown
---
allowed-tools: Read, Edit
description: Collaborative draft work — ...
argument-hint: <file_path>
---

# Workshop

## 1. Identify the file
...

## 2. Load the skills
Load the `taste` skill. Load the `draft-patterns` skill.

## 3. Read the piece
...

## 4. Assess draft maturity
[full maturity framework repeated]

## 5. Orient before editing
...

## 6. Edit based on maturity
[three-tier branching block, identical to skill]

## 7. Summarize
...
```

**After: thin wrapper (9 lines, delegates entirely to skill):**

```markdown
---
allowed-tools: Read, Edit
description: Collaborative draft work — read a piece, assess where it is in its
  development, ask one question if intent is unclear, then work in the direction the
  writer wants. Use /workshop when the goal is iterative improvement over multiple
  turns, not a mechanical one-shot edit. Distinct from /edit (applies taste rules in
  one pass) and /critique (read-only feedback). Trigger when the user says "let's work
  on this," "help me develop this draft," or hands over a rough draft with no specific
  instruction.
argument-hint: <file_path>
---

# Workshop

Load the `workshop` skill. Work through the draft at `$ARGUMENTS`.
```

The skill file (`skills/workshop/SKILL.md`) retains all process content unchanged.

## Related

- [Always Bump the Plugin Version Before Publishing Changes](../conventions/plugin-version-must-bump-on-change-2026-05-26.md) — companion convention from the same PR
