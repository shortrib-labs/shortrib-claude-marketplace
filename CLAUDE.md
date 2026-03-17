# crdant plugin

Personal Claude Code plugin — writing taste, editing commands, and daily workflow skills.

## Versioning

This plugin is installed from a marketplace. The cached copy only updates when the
version in `.claude-plugin/plugin.json` changes. **Always bump the version before
publishing changes.**

```
make patch     # 1.0.0 → 1.0.1
make minor     # 1.0.0 → 1.1.0
make major     # 1.0.0 → 2.0.0
make release   # alias for patch
make version   # print current version
```

## Config files

`config/slack-people.yaml` is gitignored — it contains PII (names, Slack handles).
Place it manually at the plugin root; skills reference it via `${CLAUDE_PLUGIN_ROOT}/config/`.
