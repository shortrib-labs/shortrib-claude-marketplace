Help me prepare for my standup.

## Gather context

1. **Read yesterday's standup.** Find the most recent file in `Replicated/Standups/` before today. Extract the "plans for today" section — these are the commitments to measure against.

2. **Read my daily note** from $1. Follow all links for more context and incorporate specific details from meeting notes, vendor files, and other references.

3. **Scan meeting notes for action items.** Look for explicit action items (e.g. "ACTION:", "TODO:", "Follow up with", "Push on") in any linked meeting notes. Collect them.

4. **Check Todoist.** Pull today's due tasks and overdue items using the find-tasks-by-date tool with "today".

5. **Ask me what I plan to accomplish** today.

## Build the narrative

Before writing, read `${CLAUDE_PLUGIN_ROOT}/skills/taste/SKILL.md` and apply all rules with the "Professional Narrative" adaptation.

6. **Open with progress against yesterday's plan.** For each item from step 1, note whether it landed, shifted, or stalled. Don't belabor items that carried over — just acknowledge them.

7. **Write the day's narrative** focusing on outcomes, accomplishments, and things I learned. Additionally:
   - Organize chronologically or thematically with paragraph breaks between major shifts
   - Link to other notes using wiki-style links (e.g., [[Company Name]], [[Project Name]]) for vendors, projects, and technical topics
   - Reference GitHub PRs and external links inline where relevant
   - Focus on outcomes and what you learned/improved, not just activities
   - Cut background context that's better kept in meeting notes (company backgrounds, detailed pricing discussions, etc.)

8. **Surface action items and blockers.** From step 3, ask which are worth calling out as blockers or follow-ups in the standup.

9. **Flag unmentioned items.** List any daily note items that didn't make it into the narrative and ask if any should be included — don't wait to be asked.

10. **Add a final paragraph** about my plans for today, incorporating what I said in step 5 and any relevant Todoist items from step 4.

## Save

Save your narrative under `Replicated/Standups/$YYYY-MM-DD.md` for today's
date and show the content to the user. Add a link to the new file at the TOP
of today's daily note (before any other content) with the text "Standup update".
