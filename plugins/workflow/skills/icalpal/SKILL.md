---
name: icalpal
description: Query macOS Calendar and Reminders using icalpal CLI. Use this skill when you need to fetch calendar events, reminders/tasks, or calendar metadata from the local macOS Calendar database. Supports filtering by date, calendar, account, and various output formats including JSON.
allowed-tools: Bash
---

# icalpal Calendar Query Skill

Query macOS Calendar events and Reminders using the icalpal command-line tool.

## Commands

### Event Commands
- `events` - Print all events
- `eventsToday` - Print events occurring today
- `eventsToday+N` - Print events from today through N days ahead (e.g., `eventsToday+7` for the week)
- `eventsNow` - Print events occurring at the present time
- `eventsRemaining` - Print events from now until midnight

### Task/Reminder Commands
- `tasks` or `reminders` - Print all tasks
- `datedTasks` - Print tasks with a due date
- `undatedTasks` - Print tasks with no due date
- `tasksDueBefore` - Print uncompleted tasks due between given dates

### Metadata Commands
- `calendars` - Print available calendars
- `accounts` or `stores` - Print calendar accounts

## Output Formats

Use `-o FORMAT` to specify output format:
- `json` - JSON format (best for programmatic use)
- `default` - Human-readable default format
- `ansi` - Colored terminal output
- `csv` - Comma-separated values
- `md` - Markdown format
- `yaml` - YAML format
- `html` - HTML format
- `xml` - XML format

**Recommendation**: Always use `-o json` when processing data programmatically.

## Date Filtering

- `--from=DATE` - Events starting on or after DATE
- `--to=DATE` - Events starting on or before DATE
- `--days=N` - Show N days of events including start date
- `-n` - Include only events from now on

DATE can be: `yesterday`, `today`, `tomorrow`, `+N`, `-N`, or any DateTime.parse() format.

## Calendar/Account Filtering

### Include/Exclude Accounts
- `--is=ACCOUNTS` - Include only these accounts
- `--es=ACCOUNTS` - Exclude these accounts

### Include/Exclude Calendars
- `--ic=CALENDARS` - Include only these calendars
- `--ec=CALENDARS` - Exclude these calendars

### Include/Exclude Reminder Lists
- `--il=LISTS` - Include only these reminder lists
- `--el=LISTS` - Exclude these reminder lists

### Calendar Types
- `--it=TYPES` - Include only these types
- `--et=TYPES` - Exclude these types
- Types: Local, Exchange, CalDAV, MobileMe, Subscribed, Birthdays, Reminders

## Task Filtering

- `--id` - Include completed reminders
- `--ed` - Exclude uncompleted reminders

## Event Filtering

- `--ia` - Include only all-day events
- `--ea` - Exclude all-day events
- `--match=FIELD=REGEX` - Include items where FIELD matches REGEX (case insensitive)

## Property Selection

### Event Properties
Available: ROWID, UUID, account, address, all_day, attendees, availability, calendar, color, conference_url_detected, count, duration, end_date, end_tz, flags, frequency, has_recurrences, interval, invitation_status, location, notes, orig_date, orig_item_id, rend_date, specifier, start_date, start_tz, status, subcal_url, symbolic_color_name, title, trigger_interval, type, unique_identifier, url, xdate

- `--iep=PROPERTIES` - Include only these event properties
- `--eep=PROPERTIES` - Exclude these event properties
- `--aep=PROPERTIES` - Add properties to default list

### Task Properties
Available: alert, all_day, assignee, badge, color, completed, due_date, flagged, grocery, group, id, list_name, location, members, messaging, notes, parent, priority, proximity, radius, shared, tags, title, url, utc_offset

- `--itp=PROPERTIES` - Include only these task properties
- `--etp=PROPERTIES` - Exclude these task properties
- `--atp=PROPERTIES` - Add properties to default list

Use `--iep=all` or `--itp=all` to include all properties.

## Sorting and Formatting

- `--sort=PROPERTY` - Sort by property
- `--std` - Sort tasks by due date
- `-r` - Reverse sort order
- `--sc` - Separate by calendar
- `--sd` - Separate by date
- `--sp` - Separate by priority
- `--li=N` - Limit to N items

## Usage Examples

### Get today's events as JSON
```bash
icalpal eventsToday -o json
```

### Get this week's events from a specific calendar
```bash
icalpal eventsToday+7 --ic="chuck@replicated.com" -o json
```

### Get events for the next 14 days excluding birthdays
```bash
icalpal eventsToday+14 --et=Birthdays -o json
```

### Get all tasks with due dates sorted by date
```bash
icalpal datedTasks --std -o json
```

### Get tasks from a specific reminder list
```bash
icalpal tasks --il="To Do" -o json
```

### Get events containing "meeting" in the title
```bash
icalpal events --match=title=meeting -o json
```

### Get remaining events today with specific properties
```bash
icalpal eventsRemaining --iep=title,start_date,end_date,location,attendees -o json
```

### List all calendars
```bash
icalpal calendars -o json
```

## Key JSON Fields

### Event Fields
- `title` - Event title
- `start_date` - Start time (Unix timestamp in event's timezone)
- `end_date` - End time (Unix timestamp)
- `sseconds` / `eseconds` - Start/end as Unix epoch seconds
- `sdate` / `edate` - Relative date strings ("today", "tomorrow", etc.)
- `sctime` / `ectime` - Formatted datetime strings
- `all_day` - 1 if all-day event, 0 otherwise
- `calendar` - Calendar name
- `account` - Account name (Google, iCloud, etc.)
- `location` - Event location
- `attendees` - Array of attendee emails
- `notes` - Event description/notes
- `conference_url_detected` - Video conference URL if detected

### Task Fields
- `title` - Task title
- `due_date` - Due date (Unix timestamp, null if undated)
- `due` - Formatted due date string
- `priority` - Priority (0=none, 1=high, 2=medium, 3=low)
- `long_priority` - Human-readable priority
- `completed` - 1 if completed, 0 otherwise
- `flagged` - 1 if flagged, 0 otherwise
- `list_name` - Reminder list name
- `notes` - Task notes
- `tags` - Array of tags

## Notes

- icalpal reads directly from the macOS Calendar SQLite database
- Changes made in Calendar.app may take a moment to appear
- Some calendars (like Google) sync periodically
- The tool is read-only; it cannot create or modify events
