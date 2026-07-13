---
name: next-stage
description: Start the next stage of a roadmap under docs/roadmaps/ by converting its stage brief into a .tasks/ feature via /to-tasks. Use when the user says "next stage", "start the next stage", or wants to continue a roadmap after finishing a feature. Companion to /to-roadmap and /next-task.
---

# Next Stage

Start the next stage of a roadmap created by `/to-roadmap`: mark the previous stage done, hand the next stage's brief to the `/to-tasks` flow, and record the stage as in progress.

## Workflow

### 1. Guard: no feature in flight

If `.tasks/` exists and contains numbered task files, stop and tell the user — the current feature must be finished via `/next-task` (or explicitly discarded) before a new stage starts.

### 2. Locate the roadmap

Find `docs/roadmaps/*/ROADMAP.md` files with unchecked stages. If the user named a roadmap in their invocation, use that one; if exactly one roadmap has open stages, use it; if several do, ask which.

### 3. Reconcile stage status (fallback)

Normally `/next-task`'s finish gate marks a stage complete in `ROADMAP.md` when its final task lands, so nothing to do here. But if a stage is still annotated as in progress while `.tasks/` is empty (a finish gate was skipped, or the stage predates the finish-gate behaviour), reconcile: verify the stage's work actually landed on the repo's default branch — the universal done-signal, regardless of review process (a merged PR and a direct merge both satisfy it). Then update its entry to `[x]` and drop the annotation. Don't commit yet — this edit rides in the new stage's plan commit (step 5). If the stage's commits are NOT on the default branch (branch abandoned, PR closed, merge never happened), surface that to the user instead of ticking it.

If every stage is checked, the roadmap is complete — tell the user and stop. The roadmap directory stays as a historical record.

### 4. Read the brief and hand off to /to-tasks

The next stage is the lowest-numbered unchecked entry. Read its brief in full, plus `ROADMAP.md` and anything the brief's "Decisions in force" section references that you need.

Then run the `/to-tasks` flow with the brief as the plan input. Per that skill's stage-brief handling: treat the brief's "Proposed tasks" as the draft breakdown, check every item under "Re-verify at start" against the actual codebase, adjust for drift, and quiz the user on the (possibly adjusted) breakdown before writing task files.

### 5. Record the stage as in progress

Before `/to-tasks` commits the plan (its final step), edit `ROADMAP.md`: annotate the stage's entry with *(in progress)* and the feature branch name. The plan commit then carries the roadmap status changes (both the previous stage's tick from step 3 and this annotation) onto the new feature branch.

## Tips

- One stage at a time — this skill inherits `/to-tasks`'s one-feature-at-a-time rule.
- Briefs are provisional by design. If re-grounding shows a stage's chunking is badly stale, redraft it with the user rather than forcing the brief through — and consider whether later briefs need the same correction noted.
- If the user wants to take stages out of order and the roadmap's dependency notes allow it, that's fine — pick the stage they name instead of the lowest-numbered one.
