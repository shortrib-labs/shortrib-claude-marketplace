---
name: slack-standup
description: Convert a standup note to Slack-ready text by replacing wiki-links with Slack channels and @mentions. Use when you have a standup note ready to post to Slack.
---

# Slack Standup Converter

Convert standup notes from Obsidian wiki-link format to Slack-ready text. Three explicit phases: convert, edit for audience, post.

## Input

Read the standup note at `Replicated/Standups/{date}.md` where `{date}` is provided as $1 (defaults to today's date YYYY-MM-DD).

## Mappings

### Vendor Slack Channels

Stored in vendor file frontmatter at `Replicated/Vendors/{name}/{name}.md`:

```yaml
---
slack_channel: "#vendor-replicated"
slack_channel_id: "C01ABCDEF"   # resolved at runtime, used for MCP posting
---
```

`slack_channel_id` is optional — resolved and saved on first MCP post.

### People @mentions

Stored in `${CLAUDE_PLUGIN_ROOT}/config/slack-people.yaml`:

```yaml
# null = use plain name (no @mention)
# Non-null entries have handle + slack_id (resolved at runtime)
Alex:
  handle: "@Alex Parker"
  slack_id: null          # resolved via slack_search_users, then saved
Ada:
  handle: "@ada"
  slack_id: "U01ABCDEF"  # previously resolved
Leah: null                # bare null = no @mention
```

## Phase 1: Convert

1. **Ask where this is going.** "What channel?" Knowing the audience shapes everything downstream — what's sensitive, what's relevant, what tone to strike.

2. **Read the standup note.**

3. **Extract items to convert**:
   - Vendor wiki-links: `[[SpecterOps]]`, `[[Salt AI]]`
   - People names: proper nouns that are colleagues
   - Other wiki-links: `[[Security Center]]`, `[[Vendor Portal]]`

4. **Determine output mode**:
   - **Copy-paste mode** (default): User will manually paste into Slack. Output `@handle` and `#channel-name`.
   - **MCP mode**: User explicitly asks to "post to Slack" or "send to #channel". Output `<@USER_ID>` and `<#CHANNEL_ID>` format, then post via `slack_send_message`.

5. **Look up all mappings and resolve IDs in batch**:
   - Collect every unresolved reference first: vendors needing channels, people needing handles, wiki-links needing replacement.
   - For vendors: read `Replicated/Vendors/{name}/{name}.md` frontmatter for `slack_channel`
   - For people: read `${CLAUDE_PLUGIN_ROOT}/config/slack-people.yaml`
   - **MCP mode additionally**: collect all missing `slack_id` and `slack_channel_id` values, then resolve them together:
     - Use `slack_search_users` for all people with `slack_id: null` (fire lookups in parallel, not one at a time)
     - Use `slack_search_channels` for all missing channel IDs
     - Present all matches for confirmation in one pass

6. **Ask about unknowns ONE AT A TIME** (humans cannot parallel process):
   - Vendor: "What Slack channel for [[VendorName]]?"
   - Person: "Should {Name} get an @mention? If yes, what handle?"
   - Other link: "What to do with [[LinkName]]? (channel, plain text, or remove)"

7. **Produce the converted text** with all replacements applied.

## Phase 2: Edit for Audience

The standup note was written for you. The Slack post is for your team. These are different audiences.

8. **Flag sensitive content.** Scan the converted text and proactively identify:
   - **Compensation and cost figures** — MBO details, salary, pricing analysis, budget numbers
   - **Pointed comments about specific people** — criticism, frustration, "silence as assent" type remarks
   - **Internal tooling and personal workflow** — plugin work, dotfile changes, things the audience doesn't care about
   - **Detailed analysis better kept internal** — full vendor assessments, strategic musings not ready for broadcast

   For each flagged item, recommend: **keep**, **soften** (suggest specific rewording), or **cut**. Present them all, then let the user decide.

9. **Apply the user's decisions.** Trim, soften, or keep as directed. If nothing was flagged or the user approves everything, move on.

## Phase 3: Post

10. **Output Slack-ready text** (do not save to file):
    - **Copy-paste mode**:
      - Vendor links → `#channel-name`
      - People → `@handle` or plain name
    - **MCP mode**:
      - Vendor links → `<#CHANNEL_ID>` (clickable in Slack)
      - People → `<@USER_ID>` (clickable in Slack), or plain name if null
    - Both modes:
      - Other links → per user instruction
      - Preserve formatting (code blocks, backticks)

11. **Save new mappings.** Don't skip this — it's easy to forget in the rush to post.
    - Add `slack_channel` and `slack_channel_id` frontmatter to vendor files for any newly resolved channels
    - Add people to `${CLAUDE_PLUGIN_ROOT}/config/slack-people.yaml` for any newly resolved handles or IDs
    - Confirm what was saved.

12. **Post to Slack** (MCP mode only):
    - Show the fully formatted message to the user for final review
    - On approval, use `slack_send_message` to post to the target channel
    - Confirm success with a link or timestamp

## Special Cases

- **Appian Custom Demo**: Not a vendor file - ask user for replacement string
- **Wiki-links with display text**: `[[File|Display]]` - use display text context
- **Repeated references**: Use same mapping consistently throughout
