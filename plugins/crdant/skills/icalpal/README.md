# icalpal Skill

A Claude Code skill for querying macOS Calendar and Reminders using the icalpal command-line tool.

## What is icalpal?

[icalpal](https://github.com/ajrosen/icalpal) is a command-line tool that reads the macOS Calendar database directly, allowing you to query events and reminders without needing to use AppleScript or the Calendar app.

## Prerequisites

Install icalpal via Homebrew:
```bash
brew install icalpal
```

## Capabilities

This skill enables Claude Code to:
- Fetch calendar events for today, a date range, or the current time
- Query reminders/tasks including dated and undated items
- Filter by calendar, account, or calendar type
- Output in various formats (JSON recommended for processing)
- Search events/tasks by regex patterns
- List available calendars and accounts

## Example Prompts

- "What meetings do I have today?"
- "Show me my events for the next week"
- "What tasks are due this week?"
- "List all my calendars"
- "Find events with 'standup' in the title"
- "What's on my personal calendar tomorrow?"

## Skill Files

- `SKILL.md` - Full documentation and command reference
- `README.md` - This file

## Output Format

The skill uses JSON output (`-o json`) by default for programmatic processing. Key fields include:

**Events**: title, start_date, end_date, calendar, location, attendees, notes
**Tasks**: title, due_date, priority, completed, list_name, notes, tags

## Limitations

- Read-only: Cannot create or modify calendar events
- Local only: Reads from the macOS Calendar database
- Sync delay: Recently added events may take time to appear
