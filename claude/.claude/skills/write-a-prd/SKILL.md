---
name: write-a-prd
description: Generate a lean Product Requirements Document (PRD) markdown file for a feature through a short interactive flow. Use when the user wants to write a PRD, draft a spec for a feature, or mentions "PRD" / "product requirements".
---

Generate a lean PRD as a markdown file through a short interactive flow. The PRD should be 1-3 pages, bullet-heavy, link-heavy, and outcome-oriented — not a 20-page contract.

## Phase 1 — Seed

If the user did not include a feature description with the invocation, ask for one in 1-3 sentences. Otherwise, proceed.

## Phase 2 — Clarifying questions (one batch, max 5)

In a SINGLE message, ask 3-5 critical orthogonal questions. Use lettered multi-choice options where the answer space is small, and always include "other: ___" so the user isn't boxed in. Skip any question already answered by the seed.

Cover these gaps (pick the 3-5 most load-bearing for this feature):

- **Primary user + context** — who, in what role, in what situation?
- **Core problem + current workaround** — what's broken or missing today, and what do users do instead?
- **Success metric** — 1-2 measurable signals (usage + impact) that tell us this worked.
- **Out of scope** — what are we explicitly NOT doing?
- **Hard constraints** — deadline, platforms, dependencies, compliance asks.

Do NOT walk a decision tree one question at a time — PRD inputs are mostly orthogonal. Batching is faster and lower friction. (If the user wants to stress-test a design with branching follow-ups, that's the `grill-me` skill's job, not this one.)

## Phase 3 — Draft the file

Write the PRD to `./prds/prd-<kebab-feature-name>.md` (create the `prds/` directory if missing). If the user named a different location, use that.

Use this section template. Skip optional sections if they'd be empty. Mark genuine unknowns as **Open Questions** — do NOT fabricate to fill space.

```markdown
# <Feature Name>

## TL;DR
2-3 sentences: what + who + why now.

## Problem & Context
What's broken or missing today. Evidence it's real (data, support tickets, user quotes if available). Why it matters now.

## Goals
1-3 outcomes. Outcome language ("reduce time-to-first-value"), not output language ("ship a button").

## Non-Goals
Explicit scope cuts. What we are NOT doing in this iteration, and why.

## Target Users
Named personas with role + context. Not generic "users".

## User Stories
3-7 max. Format: "When [situation], [user] wants to [action] so that [outcome]."

## Requirements
- Functional requirements as bullets.
- Non-functional (perf / security / a11y / i18n) only if load-bearing.

## UX / Design Notes (optional)
Link to mockups. Call out key interaction decisions, not pixel specs.

## Technical Considerations (optional)
Known constraints, dependencies, risks. Link to design docs rather than embedding them. Not a substitute for an engineering design doc.

## Success Metrics
2-3 measurable signals. How we'll know this worked at 30 / 60 / 90 days.

## Rollout
Phases (alpha/beta/GA, or feature-flag plan). Rough timeline. Release criteria.

## Open Questions
Explicit unknowns + who owns answering each.
```

After writing the file, tell the user the path and show a quick summary of what's in it (one-line per section).

## Phase 4 — Iterate

Ask: *"Want to refine any section? Common asks: tighten metrics, add non-goals, expand a user story, cut scope."*

Edit in place via the Edit tool. Do NOT re-interview the user from scratch. Stop when the user signals they're done.

## Anti-patterns to avoid in the output

- Solutions before problem framing.
- Vague generic personas ("users", "customers").
- Missing or unmeasurable success metrics.
- No non-goals (invites scope creep).
- Walls of prose. Default to bullets.
- Over-specifying implementation (HOW) instead of WHAT/WHY.
- Embedding mockup images / long research dumps. Link out instead.
- Padding empty sections. Cut them or mark as Open Questions.

## Sizing

Match depth to feature size. A small feature is a one-pager. A major initiative may need the full template. If in doubt, err shorter — PRDs that aren't read don't help anyone.
