---
name: word-choice
description: A fast, surgical pass that deletes or swaps words that leak the wrong tone — cold or negative words ("Fine," "However," "Unfortunately"), authority-undercutting hedges ("just," "I think," "maybe"), and dead-weight filler ("very," "really," "actually"). Layers on top of taste for a quick word-level cleanup. Use for a "delete these words" pass on any short piece — email, Slack, update — before sending. Inspired by Wes Kao's "Take 3 minutes to delete these words."
allowed-tools: Read
---

# Word Choice

A word-level pass to run after the main taste pass, not instead of it. Taste
governs sentences, paragraphs, and structure. This governs individual words —
the ones that quietly change your tone.

The premise: in text you have no face, no voice, no timing. A word that reads as
neutral out loud reads as cold, unsure, or negative on the page. Word choice is
a free way to be strategic. The right word makes you sound warm, certain, and in
control. The wrong one makes you sound passive, defensive, or annoyed — without
your ever meaning it.

Run this as a `ctrl-F` sweep. For each word below, find it and decide: cut it,
or swap it. Most of the time you cut.

## Tone leaks — words that read colder than you mean

These are neutral or even polite out loud. On the page they chill the room. This
is the pass most people skip.

- **Fine** — "Fine" in text reads as *not* fine. You have no tone of voice to
  carry the warmth, so it lands flat or clipped. Say the positive version:
  "Sounds good," "That works," "Happy to."
- **However** — a formal, throat-clearing way to say "but." It makes whatever
  follows sound more like a rebuttal than it is. Use "but," or restructure so you
  don't need a pivot at all. (Taste already bans it as an AI transition — this is
  the same rule, applied by hand.)
- **Unfortunately** — pre-loads bad news and makes it sound worse. Often the
  sentence delivers the news fine without it. Cut it, or lead with the path
  forward instead of the regret.
- **Actually** — reads as corrective, as if the reader was wrong. "Actually,
  the deadline is Friday" sounds like a gotcha. Just state it: "The deadline is
  Friday."
- **You should have / you didn't / you failed to** — second-person blame. Recast
  around the fix, not the fault: "Let's get the sign-off before we ship" beats
  "You didn't get sign-off."

## Authority-undercutters — hedges that shrink you

These signal your own uncertainty rather than the subject's real complexity. They
ask permission to have said the thing at all. Cut them and the sentence gets more
confident without changing its meaning.

- **Just** — "I just wanted to check," "just a quick question." It minimizes you
  and the ask. Delete it; the sentence is stronger and no less polite.
- **I think / I feel like / I believe** — you're the one writing it, so we know
  you think it. State the claim. Keep it only when you're genuinely flagging
  uncertainty on purpose.
- **Maybe / perhaps / possibly / kind of / sort of** — softeners that blur a
  clear point. If you mean it, say it. If you're truly unsure, name the specific
  uncertainty instead of hedging the whole sentence.
- **I'm no expert, but / this might be dumb, but / does that make sense?** —
  pre-apologies and permission-seeking. They undercut the idea before the reader
  reaches it. Cut the frame; let the idea stand.
- **Quick / real quick** — "a quick question," "quick call." It pre-negotiates
  the reader's time and shrinks the request. Ask the question.

## Dead weight — filler that adds nothing

Pure padding. Deleting these never costs meaning; it only tightens.

- **Very / really / so / quite / pretty** — intensifiers that weaken. "Very
  important" is less than "important." Pick a stronger word or drop the modifier.
- **Actually / basically / literally / honestly / obviously** — verbal tics on
  the page. Cut on sight.
- **In order to** → **to**. **The fact that** → **that** (or restructure).
  **At this point in time** → **now**. **Due to the fact that** → **because**.
- **Currently / at the moment** — usually implied by the present tense. Cut.
- **In my opinion / I would say / it seems like** — throat-clearing before a
  claim you're about to make anyway.

## How this relates to taste

`taste` bans hedging and AI transitions as a category. This skill is the fast,
concrete checklist for enforcing that by hand on a short piece — the words to
literally search for. When a full `/edit` pass runs taste, it covers this. Reach
for `word-choice` on its own when you want a three-minute cleanup on an email,
Slack message, or update, not a full rewrite.

## The test

Read the sentence with the word and without it. If the meaning survives the cut,
the word was filler — delete it. If the tone warms up when you swap it, the
original was leaking. Keep only the words that earn their place.

## Source

The tone-word framing draws on Wes Kao's "Take 3 minutes to delete these words
and improve your writing forever"
(https://newsletter.weskao.com/p/take-3-minutes-to-delete-these-words). The
central idea is hers: language is a free lever for tone, and a handful of words
quietly work against you.
