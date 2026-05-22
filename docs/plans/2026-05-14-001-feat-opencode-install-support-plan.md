# Plan: Add OpenCode Installation Support to shortrib-claude-marketplace

**Created:** 2026-05-14
**Status:** Active
**Depth:** Standard

---

## Problem Frame

The `shortrib-claude-marketplace` repository is currently a Claude Code-only plugin marketplace. It contains four interdependent plugins (taste, writing, strategy, workflow) with skills, commands, and MCP server configurations. There is no mechanism to install these plugins into OpenCode, which is a gap for users who want to use these editorial and workflow tools across multiple AI assistant platforms.

The goal is to add OpenCode as a supported installation target, similar to how the `compound-engineering-plugin` supports multiple targets through its converter/installer CLI. Because this repository is currently a simple static plugin collection (no build tooling beyond a Makefile for versioning), the solution should be lightweight and additive rather than requiring a full TypeScript/Bun toolchain.

---

## Scope Boundary

**In scope:**
- Install script that converts Claude-format plugins to OpenCode format
- Skill copying to `~/.config/opencode/skills/<name>/SKILL.md`
- Command conversion from Claude frontmatter (`--- allowed-tools: ... description: ... ---`) to OpenCode command `.md` files (YAML frontmatter with `description`, `model`)
- MCP server config merging into existing `~/.config/opencode/opencode.json`
- Path rewriting: `.claude/` → `.opencode/`, `~/.claude/` → `~/.config/opencode/`, `${CLAUDE_PLUGIN_ROOT}` → `${OPENCODE_PLUGIN_ROOT}`
- Support for both global (`~/.config/opencode/`) and project-local (`.opencode/`) installation scopes
- Per-plugin install (install just `taste` or `writing`) and full marketplace install

**Deferred to follow-up work:**
- Agent conversion (current repo has no agents)
- Hook/plugin conversion (current repo has no hooks)
- npm package publishing (`bunx @.../shortrib-marketplace install ...`)
- Codex, Cursor, Gemini, or other target platform support
- CI/CD automation for OpenCode publishing
- GUI or TUI installer

**Outside this product's identity:**
- Rewriting the core plugin content to be platform-agnostic (path references in skills/commands are the user's responsibility)
- Converting the repo itself from a Claude Code marketplace to an OpenCode-native marketplace

---

## Requirements Traceability

| Req | Description | Origin |
|-----|-------------|--------|
| R1 | Install skills into OpenCode's skill discovery path | User request |
| R2 | Convert Claude commands to OpenCode command `.md` format | User request, OpenCode spec |
| R3 | Preserve existing `opencode.json` config when installing MCP servers | OpenCode spec, ADR-002 from reference |
| R4 | Support per-plugin and full-marketplace install | User workflow |
| R5 | Rewrite Claude-specific paths to OpenCode equivalents | Cross-platform correctness |
| R6 | Non-destructive install (backup before overwrite, merge config) | Reference repo pattern |

---

## System-Wide Impact

- **End users:** Gain ability to use shortrib plugins in OpenCode. Must understand that command behavior depends on OpenCode tool availability (some OpenCode tools differ from Claude Code tools).
- **Developers:** New install script to maintain. No changes to existing Claude plugin structure.
- **Documentation:** README and CLAUDE.md need OpenCode install instructions.

---

## High-Level Technical Design

The solution is a **Python install script** (`scripts/install-opencode.py`) that reads the existing Claude plugin structure and emits OpenCode-compatible files.

**This illustrates the intended approach and is directional guidance for review, not implementation specification.**

```
User runs: python3 scripts/install-opencode.py [plugin-name|--all] [--scope global|local]

Script flow:
1. Parse marketplace.json or plugin.json
2. For each selected plugin:
   a. Copy skills/ → ~/.config/opencode/skills/ (transform content)
   b. Convert commands/ → ~/.config/opencode/commands/*.md
   c. Read .mcp.json, merge into existing opencode.json
3. Write managed install manifest for future cleanup
```

**Why Python over TypeScript/Bun?**
- The repo already uses Python in the Makefile for version manipulation.
- Adding a full Node/Bun toolchain (package.json, tsconfig, dependencies) would be disproportionate for a simple file-copy-and-transform operation.
- Python has excellent YAML/JSON handling and is preinstalled on macOS/Linux.
- The reference repo's TypeScript CLI is justified by its complexity (7 target platforms, converters, agents, hooks). This repo needs only OpenCode.

---

## Key Technical Decisions

### Decision 1: Python install script, not TypeScript CLI
**Context:** The repo has no Node.js tooling. Adding it for a single-target converter is overkill.
**Alternative rejected:** Port the reference repo's Bun/TypeScript CLI — too much infrastructure for 4 plugins.
**Reversal trigger:** If we later add 3+ more target platforms, reconsider a unified TypeScript CLI.

### Decision 2: Commands as individual `.md` files, not `opencode.json` entries
**Context:** OpenCode supports both formats. `.md` files are non-destructive (additive) and don't risk overwriting user config.
**Rationale:** Matches ADR-001 from the reference repo. OpenCode resolves commands by filename at runtime.
**Reversal trigger:** If OpenCode deprecates `.md` command files.

### Decision 3: Deep-merge `opencode.json`, never overwrite
**Context:** Users have personal `opencode.json` settings (model, theme, API keys, existing MCP servers).
**Rationale:** Matches ADR-002 from the reference repo. Plugin MCP servers are merged; user values win on conflict.
**Reversal trigger:** If OpenCode adds a separate plugin MCP registration mechanism.

### Decision 4: No `--permissions` flag; default to none
**Context:** The current repo's commands use `allowed-tools` frontmatter, but OpenCode permissions are global and complex to map correctly.
**Rationale:** OpenCode defaults are permissive. Users can configure permissions manually. Avoids the semantic inversion problem the reference repo solved.
**Reversal trigger:** If OpenCode adds per-command permission scopes.

---

## Implementation Units

### U1. Create install script infrastructure
**Goal:** Add the install script, its Python dependencies, and argument parsing.

**Requirements:** R1, R4

**Dependencies:** None

**Files:**
- `scripts/install-opencode.py` (new)
- `scripts/requirements.txt` (new)
- `README.md` (modify — add OpenCode install section)

**Approach:**
- Create `scripts/install-opencode.py` with argparse for `[plugin|--all]`, `[--scope global|local]`, `[--dry-run]`
- Parse `.claude-plugin/marketplace.json` to discover plugins
- Parse individual `plugins/{name}/.claude-plugin/plugin.json` for metadata
- Determine output root: `~/.config/opencode/` (global) or `./.opencode/` (local)
- Create output directories: `skills/`, `commands/`
- Read existing `opencode.json` if present

**Patterns to follow:**
- Reference repo's `resolveOpenCodePaths()` logic for global vs. local scope
- Makefile's Python usage for cross-platform compatibility

**Test scenarios:**
- Happy path: `python3 scripts/install-opencode.py --all --scope global` creates `~/.config/opencode/skills/taste/SKILL.md`
- Per-plugin: `python3 scripts/install-opencode.py taste` installs only taste
- Local scope: `python3 scripts/install-opencode.py --scope local` writes to `.opencode/`
- Dry run: `--dry-run` prints what would happen without writing files
- Missing plugin: `python3 scripts/install-opencode.py nonexistent` exits with error

**Verification:**
- Script runs without errors on macOS and Linux
- Output directories are created with correct permissions
- Script is executable: `chmod +x scripts/install-opencode.py`

---

### U2. Convert and install skills
**Goal:** Copy skills from `plugins/{name}/skills/` to OpenCode skill directory with content transformation.

**Requirements:** R1, R5

**Dependencies:** U1

**Files:**
- `scripts/install-opencode.py` (modify — add `install_skills()`)

**Approach:**
- For each skill directory in `plugins/{name}/skills/<skill-name>/`:
  - Copy `SKILL.md` to `<output>/skills/<skill-name>/SKILL.md`
  - If `<skill-name>/` contains additional files (e.g., `README.md`), copy them too
- Apply content transformation:
  - Replace `.claude/` with `.opencode/`
  - Replace `~/.claude/` with `~/.config/opencode/`
  - Replace `${CLAUDE_PLUGIN_ROOT}` with `${OPENCODE_PLUGIN_ROOT}`
- Handle path collisions: if skill already exists, backup existing before overwriting

**Patterns to follow:**
- Reference repo's `transformSkillContentForOpenCode()` path rewriting rules
- Reference repo's backup-before-overwrite pattern

**Test scenarios:**
- Happy path: `plugins/taste/skills/taste/SKILL.md` → `~/.config/opencode/skills/taste/SKILL.md`
- Multi-file skill: `plugins/workflow/skills/icalpal/` (has `SKILL.md` + `README.md`) → both files copied
- Path rewriting: Skill content containing `.claude/skills/style-analysis/SKILL.md` is rewritten to `.opencode/skills/style-analysis/SKILL.md`
- Backup: Installing over existing `~/.config/opencode/skills/taste/SKILL.md` backs up old file with timestamp
- Dry run: `--dry-run` shows copy operations without writing

**Verification:**
- Installed skills are discoverable by OpenCode (test with `opencode skills list` or verify file exists in correct path)
- Skill content has no `.claude/` or `~/.claude/` references

---

### U3. Convert and install commands
**Goal:** Convert Claude command `.md` files to OpenCode command `.md` files and install them.

**Requirements:** R2, R5

**Dependencies:** U1

**Files:**
- `scripts/install-opencode.py` (modify — add `install_commands()`)

**Approach:**
- For each command file in `plugins/{name}/commands/<command-name>.md`:
  - Parse YAML frontmatter (currently has `allowed-tools`, `description`, `argument-hint`)
  - Create OpenCode-compatible frontmatter with `description` (required) and optionally `model`
  - The command body becomes the markdown content after frontmatter
  - Write to `<output>/commands/<command-name>.md`
- Handle colon in command names: OpenCode supports nested paths, so `workflows:plan` can be written as `commands/workflows/plan.md` or flattened to `commands/workflows-plan.md`. **Decision:** Flatten to single filename with hyphen replacement for simplicity: `workflows-plan.md`.
- Skip commands with `disable-model-invocation` if present (not currently in this repo)

**Command frontmatter mapping:**

| Claude frontmatter | OpenCode frontmatter | Notes |
|--------------------|---------------------|-------|
| `description` | `description` | Preserved |
| `allowed-tools` | — | Not supported in OpenCode command frontmatter |
| `argument-hint` | — | Not supported; included in body text instead |
| `model` | `model` | If present and not `inherit` |

**Patterns to follow:**
- Reference repo's `convertCommands()` logic
- OpenCode spec: commands as `.md` files with YAML frontmatter

**Test scenarios:**
- Happy path: `commands/edit.md` with `allowed-tools: Read, Edit` and `description: ...` → `commands/edit.md` with `description: ...` in YAML frontmatter, no `allowed-tools`
- Model preservation: If command has `model: claude-sonnet-4` in frontmatter, output has `model: claude-sonnet-4` (OpenCode uses `provider/model-id` format; we pass through as-is for now)
- Colon in name: `commands/slack-standup.md` stays `commands/slack-standup.md` (flat)
- Path rewriting: Command body containing `Replicated/Standups/` is preserved (workspace-specific, not platform-specific)
- Path rewriting: Command body containing `.claude/skills/taste/SKILL.md` is rewritten to `.opencode/skills/taste/SKILL.md`
- Backup: Installing over existing command file backs up old version

**Verification:**
- Command files are valid markdown with YAML frontmatter (test with Python `yaml.safe_load` on frontmatter)
- Commands are discoverable by OpenCode in `commands/` directory

---

### U4. Handle MCP config and opencode.json merging
**Goal:** Merge plugin MCP server configs into OpenCode's `opencode.json` without destroying user settings.

**Requirements:** R3

**Dependencies:** U1

**Files:**
- `scripts/install-opencode.py` (modify — add `merge_opencode_config()`)
- `CLAUDE.md` (modify — document OpenCode MCP behavior)

**Approach:**
- Read existing `<output>/opencode.json` if present
- Parse plugin `.mcp.json` (only `workflow` plugin has this currently)
- Convert Claude MCP format to OpenCode MCP format:
  - Claude: `{ "mcpServers": { "name": { "type": "http", "url": "..." } } }`
  - OpenCode: `{ "mcp": { "name": { "type": "http", "url": "..." } } }` (note: key is `mcp` not `mcpServers`)
  - Handle `type: http` → `type: "http"` (already same)
  - Handle `command`/`args` style → same in OpenCode
  - Handle `oauth` field → preserve as-is
- Deep-merge: plugin MCP entries added to existing `mcp` object; user entries are preserved
- Write merged config back to `opencode.json`
- Backup existing `opencode.json` before writing

**Important:** Only merge `mcp` key from plugin. Do NOT merge `permission`, `tools`, `model`, or other keys. The plugin does not define these.

**Patterns to follow:**
- Reference repo's `mergeOpenCodeConfig()` deep-merge logic
- User-wins-on-conflict strategy

**Test scenarios:**
- Happy path: Fresh install on empty `~/.config/opencode/` creates `opencode.json` with only `mcp` section
- Merge: Existing `opencode.json` with `{ "model": "openai/gpt-4o", "mcp": { "existing-server": {...} } }` → merged result keeps `model` and `existing-server`, adds plugin servers
- Backup: Existing `opencode.json` is backed up with timestamp before merge
- No MCP plugin: Installing `taste` (no `.mcp.json`) does not create or modify `opencode.json`
- Invalid existing JSON: Warn user and proceed with plugin-only config (do not crash)

**Verification:**
- `opencode.json` is valid JSON
- User's existing keys (model, theme, etc.) are preserved after install
- Plugin MCP servers are present in `mcp` section

---

### U5. Add managed install manifest for cleanup
**Goal:** Track what the installer owns so future runs or a cleanup script can remove old files.

**Requirements:** R6

**Dependencies:** U1, U2, U3, U4

**Files:**
- `scripts/install-opencode.py` (modify — add manifest tracking)
- `scripts/cleanup-opencode.py` (new — optional cleanup script)

**Approach:**
- After installing, write a manifest file to `<output>/shortrib-marketplace/install-manifest.json`
- Manifest records: installed plugins, skills, commands, MCP servers, and timestamp
- On subsequent installs, read manifest and remove files that are no longer part of the new bundle (idempotent install)
- Provide a `scripts/cleanup-opencode.py` script that reads the manifest and removes all shortrib-owned files

**Manifest schema (directional guidance):**
```json
{
  "version": 1,
  "installed_at": "2026-05-14T10:00:00Z",
  "plugins": ["taste", "writing"],
  "skills": ["taste", "style-analysis", "community-post"],
  "commands": ["edit", "style-analyze", "community-post"],
  "mcp_servers": ["todoist", "fetch"]
}
```

**Test scenarios:**
- First install: manifest is created
- Re-install with fewer plugins: old plugin files are removed, new ones added
- Re-install same plugins: idempotent (no duplicate files)
- Cleanup script: removes all shortrib-owned files and manifest, leaves user config untouched
- Dry run: manifest is not written, but what-would-be-written is printed

**Verification:**
- Manifest file is valid JSON
- Cleanup script removes only shortrib-owned files
- Re-install is idempotent

---

### U6. Update documentation
**Goal:** Document OpenCode installation in README and CLAUDE.md.

**Requirements:** R1, R4

**Dependencies:** U1–U5

**Files:**
- `README.md` (modify)
- `CLAUDE.md` (modify)

**Approach:**
- README: Add "OpenCode Installation" section with examples:
  ```bash
  # Install all plugins
  python3 scripts/install-opencode.py --all

  # Install specific plugins
  python3 scripts/install-opencode.py taste writing

  # Install to project-local .opencode/
  python3 scripts/install-opencode.py --all --scope local

  # Preview what would be installed
  python3 scripts/install-opencode.py --all --dry-run
  ```
- CLAUDE.md: Add OpenCode development notes (scope differences, path conventions)
- Document that OpenCode does not support `allowed-tools` per-command; permissions are global
- Document that workspace-specific paths (`Replicated/Standups/`) are preserved as-is and may need user customization

**Verification:**
- README instructions are accurate and runnable
- CLAUDE.md explains the OpenCode install process for developers

---

## Assumptions

1. **Python 3.8+ is available.** The script uses `pathlib`, `argparse`, and `json` (stdlib). For YAML parsing of command frontmatter, the script may need `PyYAML` (listed in `requirements.txt`). If PyYAML is unavailable, fall back to a simple regex-based frontmatter parser.
2. **OpenCode config directory is `~/.config/opencode/` or `./.opencode/`**. Matches OpenCode spec as of 2026-04-19.
3. **Skill content compatibility.** The existing `SKILL.md` files are largely platform-agnostic except for path references. The script handles the common path rewrites, but workspace-specific paths (e.g., `Replicated/Standups/`) are preserved.
4. **No agents or hooks to convert.** The current repo has no `agents/` or `hooks/` directories. If these are added later, the install script will need extension.

---

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Overwriting user's `opencode.json` | Medium | High | Deep-merge with backup (U4). User keys always win. |
| Skill/command name collisions with user files | Medium | Medium | Backup before overwrite (U2, U3). Manifest tracks ownership (U5). |
| OpenCode format changes | Low | Medium | Script is simple Python; easy to adapt. Pin to spec version in comments. |
| Windows path issues | Low | Medium | Use `pathlib.Path` throughout. Test on Windows if needed. |
| Missing Python/PyYAML | Low | Low | Provide `requirements.txt`. Graceful fallback to stdlib-only frontmatter parser. |

---

## Deferred to Follow-Up Work

- **Agent conversion:** If agents are added to the repo, extend `install-opencode.py` to convert and install them to `agents/<name>.md`.
- **Hook/plugin conversion:** If hooks are added, generate TypeScript plugin files for `plugins/`.
- **Multi-target CLI:** If supporting 3+ platforms, consider migrating to a TypeScript/Bun CLI similar to the reference repo.
- **npm publishing:** Package the install script as a pip package or npm package for easier distribution.
- **Auto-discovery of opencode config dir:** Respect `OPENCODE_CONFIG_DIR` environment variable.

---

## Success Criteria

- [ ] `python3 scripts/install-opencode.py --all --dry-run` shows a complete plan without errors
- [ ] `python3 scripts/install-opencode.py --all` installs all 8 skills and 7 commands to `~/.config/opencode/`
- [ ] Existing `opencode.json` is preserved and merged with MCP config from workflow plugin
- [ ] Re-installing is idempotent (same result, no duplicates)
- [ ] `python3 scripts/cleanup-opencode.py` removes all shortrib-owned files
- [ ] README documents OpenCode installation with copy-pasteable commands
- [ ] All path references in installed skills point to `.opencode/` or `~/.config/opencode/`, never `.claude/`
