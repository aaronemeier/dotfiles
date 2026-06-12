---
name: plan-from-prd
description: Generate an actionable, checkbox-driven implementation task list from an existing PRD markdown file. Use when the user wants to break a PRD into tasks, generate a plan from a PRD, or mentions "plan from PRD" / "tasks from PRD". Companion to the write-a-prd skill.
---

Convert a PRD into a concrete, checkbox-driven implementation task list. The output is a single markdown file the implementer ticks through as they work — parent tasks ≈ 5, each broken into actionable sub-tasks, with real file paths grounded in the actual repo.

This skill stops after writing the file. It does NOT start implementing.

## Phase 1 — Locate the PRD

- If the user passed a path, use it.
- Otherwise, look in `./prds/` for `prd-*.md` files. If exactly one exists, use it. If multiple exist, list them and ask which.
- If none exist, ask the user where the PRD lives.
- Read the PRD with the Read tool — do not paraphrase from memory.

## Phase 2 — Sanity-check the PRD

- If the PRD has an **Open Questions** section with unresolved items that materially affect implementation (architecture, scope, hard constraints), surface them in one short message and ask the user whether to resolve first or proceed anyway. Don't lecture — one bullet per question.
- If the PRD looks unstructured / not produced by `write-a-prd` (no clear Requirements section), say so and confirm before continuing.
- Otherwise proceed silently.

## Phase 3 — Generate parent tasks (no sub-tasks yet)

Inspect the actual repo before drafting:

- Use Glob / Grep to find existing files in the domains the PRD touches (models, views, serializers, clients, tasks, admin, templates, tests).
- Note the project's test runner / framework conventions by reading config files (e.g. `pytest.ini`, `pyproject.toml`, `package.json`, `jest.config.*`). Do NOT hardcode a runner.

Then write the file to `./tasks/tasks-<kebab-feature-name>.md` (derived from the PRD filename: `prds/prd-foo.md` → `tasks/tasks-foo.md`). Create the `tasks/` directory if missing. If the user named a different location, use that.

Initial file contents — parent tasks only, no sub-tasks expanded:

```markdown
# Tasks: <Feature Name>

> Source PRD: <relative path to PRD>

## Relevant Files

(populated in Phase 4 — leave empty or with a short placeholder for now)

## Notes

- <Project-specific test command, if detected>
- <Any other implementer-relevant convention worth flagging>

## Tasks

- [ ] 0.0 Create feature branch
- [ ] 1.0 <Parent task>
- [ ] 2.0 <Parent task>
- [ ] 3.0 <Parent task>
- [ ] 4.0 <Parent task>
- [ ] 5.0 <Parent task>
```

Aim for ~5 parent tasks (use judgment — small features get fewer). Each parent is a meaningful chunk of work, not a single line of code. Order them so earlier tasks unblock later ones.

After writing the file, tell the user the path and show the parent task list. Then ask:

> *Reply `go` to expand into sub-tasks, or edit the parent list first.*

## Phase 4 — Wait for `go`, then expand

Once the user replies `go` (or equivalent confirmation):

1. **Expand each parent into sub-tasks** — concrete, actionable, junior-developer-readable. Sub-tasks should reference real file paths, function names, or model names where possible. Avoid vague verbs like "handle", "support", "implement"; prefer "add `X` field to `Y` model", "create `POST /signup/...` view in `signup/views.py`", "register `SignupRequest` in `admin.py`".

2. **Populate the `Relevant Files` section** — list files the implementer will touch, each with a one-line purpose. Pair source files with their test files (using whatever test convention the repo uses — alongside, in `tests/`, etc.). Ground these in your repo inspection from Phase 3, don't invent paths.

3. **Update `Notes`** — replace placeholders with concrete commands: how to run the test suite, any dev-server / migration / lint commands the implementer will need.

4. **Edit the file in place** via the Edit tool. Don't rewrite from scratch.

Final structure:

```markdown
# Tasks: <Feature Name>

> Source PRD: <path>

## Relevant Files

- `path/to/file.py` — purpose.
- `path/to/test_file.py` — tests for `file.py`.
- ...

## Notes

- Run tests with: `<actual command>`.
- <other conventions>.

## Tasks

- [ ] 0.0 Create feature branch
  - [ ] 0.1 Create and check out a new branch (e.g. `git checkout -b <existing-repo-branch-style>`)
- [ ] 1.0 <Parent task>
  - [ ] 1.1 <Sub-task>
  - [ ] 1.2 <Sub-task>
- [ ] 2.0 <Parent task>
  - [ ] 2.1 <Sub-task>
- ...
```

Tell the user the file is fully expanded and remind them: as they work, they should flip `- [ ]` to `- [x]` per sub-task, not just per parent.

## Phase 5 — Iterate

If the user wants edits, edit in place. Don't re-interview. Don't expand into pseudocode or implementation hints — keep tasks at the "what to do" level.

**Stop here.** Do not start implementing. If the user wants to begin work, they invoke whatever execution flow they use (manual, separate skill, etc.) — that's not this skill's job.

## Anti-patterns to avoid

- Inventing file paths that don't match the repo's actual structure.
- Hardcoding `npx jest` / `pytest` / any specific runner without checking the repo.
- Vague tasks ("implement signup endpoint") instead of grounded ones ("add `POST /signup/<signup_type>/` view in `company_setup/views.py` that validates payload and creates `SignupRequest` row").
- Skipping the `go` handshake and dumping parents + sub-tasks at once. The pause is load-bearing — it lets the user reshape the skeleton cheaply.
- Including PRD content (problem framing, success metrics, user stories) in the task list. The PRD is the "what/why"; this file is the "how/in what order". Link to the PRD instead.
- Writing pseudocode in sub-tasks. One line per sub-task, no code blocks.
- Starting implementation. The skill ends at file write.

## Sizing

A small feature gets 2-3 parent tasks and a one-page file. A major initiative may get 6-8 parents and a longer file. Match the size of the task list to the PRD — if the PRD is one page, the task list shouldn't be five.
