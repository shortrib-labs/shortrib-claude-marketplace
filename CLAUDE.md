# shortrib-labs

Personal Claude Code plugin collection — writing taste, editing commands, strategy, and daily workflow.

## Structure

This repo has four plugins:

- `plugins/taste/` — Editorial standards foundation. Other plugins depend on this.
- `plugins/writing/` — Editing commands and writing voices. Depends on taste.
- `plugins/strategy/` — Strategic thinking framework. Depends on taste.
- `plugins/workflow/` — Daily operations and tool integration. Depends on taste.

Install `taste` before `writing` or `strategy` — those plugins reference it at runtime.

## Plugin Anatomy

Every plugin lives under `plugins/<name>/` with this layout:

```
plugins/<name>/
  .claude-plugin/plugin.json   # Required: name, version, description, author, keywords
  commands/<command>.md        # Slash commands — thin wrappers that delegate to skills
  skills/<skill-name>/SKILL.md # Loadable context — authoritative process definitions
```

Commands provide the `/command-name` invocation surface. Skills hold the actual workflow
logic. A command with a companion skill should be a thin wrapper: frontmatter + one
delegation line. The skill is the single authoritative source.

`plugin.json` is required for cache invalidation — see Versioning.

## Versioning

The cached copy only updates when the version in a plugin's
`.claude-plugin/plugin.json` changes. **Always bump the version
before publishing changes.** The `PLUGIN` variable is required:

```
make patch PLUGIN=writing    # 1.0.0 → 1.0.1
make minor PLUGIN=taste      # 1.0.0 → 1.1.0
make major PLUGIN=workflow   # 1.0.0 → 2.0.0
make release PLUGIN=strategy # alias for patch
make version PLUGIN=taste    # print current version
```

The authoring loop: edit files → bump version → commit → push/merge to main.

## Knowledge Store

Documented solutions, conventions, and patterns live in `docs/solutions/`,
organized by category:

- `conventions/` — authoring rules (versioning, file structure)
- `architecture-patterns/` — structural patterns for plugin design

Each file has YAML frontmatter with `module`, `problem_type`, `tags`, and
`applies_when` fields for targeted search.

**Search before implementing or debugging.** If you are adding a skill,
command, or plugin feature — or diagnosing unexpected behavior — check
`docs/solutions/` first. Use `grep` on frontmatter fields to narrow by
module or tag.

## Config files

`plugins/workflow/config/slack-people.yaml` is gitignored — it contains PII (names, Slack handles).
Place it manually in the plugin directory; skills reference it via `${CLAUDE_PLUGIN_ROOT}/config/`.
