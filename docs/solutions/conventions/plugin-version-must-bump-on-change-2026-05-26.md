---
title: Always Bump the Plugin Version Before Publishing Changes
date: 2026-05-26
category: docs/solutions/conventions/
module: shortrib-claude-marketplace
problem_type: convention
component: tooling
severity: high
applies_when:
  - Adding a new skill or command to any plugin
  - Editing an existing skill or command file
  - Deleting a skill or command
symptoms:
  - New skills or commands not visible after plugin update
  - Cached copy continues using old skill or command definitions
root_cause: missing_workflow_step
resolution_type: workflow_improvement
tags:
  - plugin-authoring
  - versioning
  - cache-invalidation
  - claude-code-plugin
  - publishing
---

# Always Bump the Plugin Version Before Publishing Changes

## Context

Plugin consumers receive a cached copy of each plugin. That cache only updates when the version field in `.claude-plugin/plugin.json` changes. Without a version bump, a published change — a new skill, a rewritten command, a deleted file — is invisible to anyone using the cached copy. The failure mode is silent: the plugin installs successfully, produces no errors, and simply runs the old version.

This was surfaced during a code review of the `feature/crdant/augments-writing-skills` branch, which added three new files to the writing plugin (`commands/workshop.md`, `skills/draft-patterns/SKILL.md`, `skills/workshop/SKILL.md`) without bumping the version. The CLAUDE.md versioning rule is explicit and unconditional: the version must change before publishing any plugin change.

## Guidance

Use the `make` targets defined in CLAUDE.md to bump the version before committing and pushing plugin changes:

```bash
make patch PLUGIN=writing    # 1.0.0 → 1.0.1  (new skills, commands, minor fixes)
make minor PLUGIN=taste      # 1.0.0 → 1.1.0  (new capabilities, significant additions)
make major PLUGIN=workflow   # 1.0.0 → 2.0.0  (breaking changes)
make release PLUGIN=strategy # alias for patch
make version PLUGIN=taste    # print current version (no change)
```

The `PLUGIN` variable is required. The `patch` increment is appropriate for most additions and edits. Use `minor` when adding a significant new capability. Use `major` only for breaking changes that require consumers to update their configuration.

## Why This Matters

The cache invalidation failure is invisible. There is no error on install, no warning in the Claude Code UI, no indication that the running version is stale. A developer who adds a new skill, publishes the plugin, and then tests it will see the old behavior with no signal about what went wrong. The only way to catch it is to know the rule before publishing — or to notice that the new content is mysteriously absent after a cache refresh.

Because the failure is silent and the check is easy to forget, it belongs in the commit flow, not as a post-hoc debugging step.

## When to Apply

- Before committing any change to a file under `plugins/<name>/` — skills, commands, config, or plugin metadata
- Before running `make release` or pushing to a branch that will be merged to main
- When reviewing PRs: check `.claude-plugin/plugin.json` for a version bump whenever the diff includes plugin file changes

## Examples

**Before (version not bumped, new files invisible to consumers):**

```json
{
  "name": "writing",
  "version": "1.0.0",
  "description": "Writing voice skills and editing commands that apply taste to real work."
}
```

Three new files added to the plugin; version unchanged. The cached copy at version 1.0.0 continues to be served.

**After (version bumped, cache invalidated):**

```json
{
  "name": "writing",
  "version": "1.0.1",
  "description": "Writing voice skills and editing commands that apply taste to real work."
}
```

```bash
make patch PLUGIN=writing
# Updates version from 1.0.0 to 1.0.1 in plugins/writing/.claude-plugin/plugin.json
```

## Related

- CLAUDE.md, Versioning section — canonical rule and make targets
- [Command as Thin Wrapper Over Skill](../architecture-patterns/command-as-thin-wrapper-over-skill-2026-05-26.md) — companion pattern from the same PR
