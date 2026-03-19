# shortrib-claude-marketplace

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin marketplace — editorial standards, writing tools, strategic thinking, and daily workflow integration.

## Plugins

### taste

The foundation. A writing taste profile derived from 547 books, 48 repeat-read authors, and hundreds of Readwise highlights. Defines what good prose looks like, what to kill, and what to preserve.

Other plugins reference taste through skill resolution, so you can swap in your own editorial standards and the writing, strategy, and workflow plugins will pick them up.

**Skills:** `taste`

### writing

Editing commands and writing voices that apply taste to real work. Analyze a writing sample to build a style guide, write community posts in a practitioner voice, or run your drafts through taste-aware editing.

**Skills:** `style-analysis`, `community-post`
**Commands:** `/edit`, `/suggest-edits`, `/critique`, `/style-analyze`, `/community-post`

### strategy

A Socratic guide for crafting strategy in the Rumelt/Larson style, adapted for an opportunity-first culture. Walks you through identifying the opportunity, reading the landscape, establishing guiding policy, and defining coherent actions — then helps you write it up.

**Skills:** `crafting-strategy`

### workflow

Daily operations — standup prep from Obsidian daily notes, calendar queries via icalpal, Slack formatting with channel and @mention resolution, and Todoist integration.

**Skills:** `obsidian`, `icalpal`, `slack-standup`
**Commands:** `/standup`, `/slack-standup`
**MCP servers:** todoist, fetch, slack

## Installation

Install the full marketplace:

```
claude plugin add shortrib-labs/shortrib-claude-marketplace
```

Or install individual plugins:

```
claude plugin add shortrib-labs/shortrib-claude-marketplace/taste
claude plugin add shortrib-labs/shortrib-claude-marketplace/writing
claude plugin add shortrib-labs/shortrib-claude-marketplace/strategy
claude plugin add shortrib-labs/shortrib-claude-marketplace/workflow
```

The writing, strategy, and workflow plugins depend on a skill named `taste` being available. Install the taste plugin from this marketplace, or provide your own — any `taste` skill that Claude Code can resolve will work, whether it comes from a plugin, a project-level SKILL.md, or anywhere else.

## Bringing your own taste

The taste plugin defines editorial standards. The other plugins reference it by skill name, not by path. To use your own:

1. Create a `taste` skill anywhere Claude Code can find it — a plugin, a `skills/taste/SKILL.md` in your project, wherever makes sense
2. Define your voice rules, kill list, and editorial standards
3. The writing, strategy, and workflow plugins will use your taste automatically

## Configuration

The workflow plugin expects a `config/slack-people.yaml` file for Slack @mention mappings. This file is gitignored because it contains names and Slack handles. Place it manually after installation:

```yaml
# config/slack-people.yaml
Alice:
  handle: "@alice"
  slack_id: null    # resolved on first use
Bob: null           # no @mention
```

The workflow plugin also ships MCP server configs for Todoist, Slack, and a general fetch server. These require their own authentication setup.

## Development

Each plugin is versioned independently. Bump versions before publishing changes:

```
make patch PLUGIN=writing    # 1.0.0 → 1.0.1
make minor PLUGIN=taste      # 1.0.0 → 1.1.0
make major PLUGIN=workflow   # 1.0.0 → 2.0.0
make version PLUGIN=strategy # print current version
```
