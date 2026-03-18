# crdant marketplace

Personal Claude Code marketplace — writing taste, editing commands, and daily workflow skills.

## Structure

This repo is a marketplace. The plugin lives in `plugins/crdant/`.

## Versioning

The cached copy only updates when the version in
`plugins/crdant/.claude-plugin/plugin.json` changes. **Always bump the version
before publishing changes.**

```
make patch     # 1.0.0 → 1.0.1
make minor     # 1.0.0 → 1.1.0
make major     # 1.0.0 → 2.0.0
make release   # alias for patch
make version   # print current version
```

## Config files

`plugins/crdant/config/slack-people.yaml` is gitignored — it contains PII (names, Slack handles).
Place it manually in the plugin directory; skills reference it via `${CLAUDE_PLUGIN_ROOT}/config/`.
