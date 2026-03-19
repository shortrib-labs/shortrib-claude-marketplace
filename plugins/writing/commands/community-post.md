---
allowed-tools: Read, Edit, Write
description: Write or complete a Replicated community post in your practitioner voice
argument-hint: <file_path>
---

# Community Post

Write or complete a community post using the community-post voice skill.

## Process

1. **Load the community-post skill** by reading `${CLAUDE_PLUGIN_ROOT}/skills/community-post/SKILL.md`. Internalize the voice — contextual storytelling, practical emphasis, anticipatory guidance, insider perspective.

2. **Read the draft** at `$ARGUMENTS`. It may be:
   - A partial draft with hints/comments about what to add
   - An outline or set of notes to expand
   - A rough draft that needs voice and polish

3. **Write or complete the post** applying the community-post voice throughout:
   - Open with a real scenario or contextual story, not a technical instruction
   - Focus on what actually works, not theoretical completeness
   - Anticipate pitfalls and address them before the reader hits them
   - Include specific commands, version numbers, file paths in code blocks
   - Use active voice consistently
   - Vary word choice

4. **Apply the taste skill's kill list.** Use the taste skill and remove any AI patterns, hedging, corporate bloat, or robotic structures. The community-post voice is specific about *how* to sound; the taste skill catches *what to avoid*.

5. **Save the result** and show a brief summary of what was written or changed.
