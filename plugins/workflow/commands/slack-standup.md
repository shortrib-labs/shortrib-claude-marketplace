---
description: Convert a standup note to Slack-ready text with channel and @mention replacements
argument-hint: <date or "today">
---

# Slack Standup

Convert a standup note to Slack-ready text.

## Process

1. **Load the slack-standup skill** by reading `${CLAUDE_PLUGIN_ROOT}/skills/slack-standup/SKILL.md`. Follow its process.

2. **Read the standup note** at `Replicated/Standups/$ARGUMENTS.md`. If the argument is "today" or empty, use today's date (YYYY-MM-DD).

3. **Follow the skill's full process**: extract wiki-links and people names, look up mappings, ask about unknowns one at a time, and output Slack-ready text.
