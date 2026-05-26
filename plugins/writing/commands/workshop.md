---
allowed-tools: Read, Edit
description: Collaborative draft work — read a piece, assess where it is in its development, ask one question if intent is unclear, then work in the direction the writer wants. Use /workshop when the goal is iterative improvement over multiple turns, not a mechanical one-shot edit. Distinct from /edit (applies taste rules in one pass) and /critique (read-only feedback). Trigger when the user says "let's work on this," "help me develop this draft," "this needs work but I'm not sure where to start," or hands over a rough draft with no specific instruction.
argument-hint: <file_path>
---

# Workshop

Work through the draft at `$ARGUMENTS` together.

## Process

### 1. Load reference skills

Load the `taste` skill. Internalize the full style rules — what to kill, what to preserve, context-specific adaptations. Then load the `draft-patterns` skill. Internalize the AI parenthetical construct checks and the draft maturity framework.

### 2. Read the piece

Read it twice:
- First for substance: what is this actually saying, who is it for, what does it need to accomplish?
- Second for voice and structure: where is it in its development?

### 3. Assess draft maturity

Use the framework from `draft-patterns` to place the piece — first draft, second draft, or near-final. This determines what kind of work is useful. Don't apply full polish to a first draft; don't ask structural questions about a near-final piece.

### 4. Orient before editing

If the piece is a first draft or the intent is unclear from context, ask *one* question before editing. Not a list — one. Aim at intent or priority: "What's this for and what do you most want to preserve?" or "Is this closer to thinking-on-paper or something you want to publish?"

Don't ask about style preferences — those are in the taste skill.

If the piece is clearly second-draft or later, or if the user's prompt already answers the intent question, skip straight to editing.

### 5. Edit based on maturity

**First draft:** Voice consistency before anything else. Commit to a POV and hold it. Strip hedging language. Flag placeholder sections explicitly — write `[NEEDS: explanation of X]` rather than filling in content you're guessing at. Don't over-polish; first drafts need structure before they need shine.

**Second draft:** Apply the full taste rules. Then run the AI parenthetical construct check from `draft-patterns` as a separate, explicit pass. The two patterns are different enough that catching one doesn't catch the other — run them sequentially.

**Near-final:** Apply taste rules, then the parenthetical construct pass, then the parenthetical insertion pass. In that order.

### 6. Summarize

Short and honest: what changed, what didn't, what should happen next. Written in voice — tight, direct, no filler. If structural problems remain that line-level editing can't fix, say so.
