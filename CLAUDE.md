# crdant marketplace

Personal Claude Code marketplace — writing taste, editing commands, strategy, and daily workflow.

## Structure

This repo is a marketplace with four plugins:

- `plugins/taste/` — Editorial standards foundation. Other plugins depend on this.
- `plugins/writing/` — Editing commands and writing voices. Depends on taste.
- `plugins/strategy/` — Strategic thinking framework. Depends on taste.
- `plugins/workflow/` — Daily operations and tool integration. Depends on taste.

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

## Config files

`plugins/workflow/config/slack-people.yaml` is gitignored — it contains PII (names, Slack handles).
Place it manually in the plugin directory; skills reference it via `${CLAUDE_PLUGIN_ROOT}/config/`.
