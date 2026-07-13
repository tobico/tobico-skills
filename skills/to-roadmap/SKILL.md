---
name: to-roadmap
description: Convert a large plan or design into a staged roadmap under docs/roadmaps/<name>/, capturing planning-session context as per-stage briefs. Use when a plan is too big for a single .tasks/ feature, when the user wants to pre-chunk a multi-stage effort, or right after a grilling/planning session whose context should be preserved. Companion to /next-stage and /to-tasks.
---

# To Roadmap

Break a large effort into sequential **stages**, checked into `docs/roadmaps/<name>/`. A roadmap is to stages what a `/to-tasks` plan is to tasks, one level up: each stage later becomes exactly one `/to-tasks` feature (one branch, one review unit), started via `/next-stage`.

## Why briefs, not task files

The planning session's context is richest **now** and evaporates at the next `/clear` — but detailed task slicing goes stale as earlier stages land and the codebase moves. So a roadmap splits the difference:

- **Capture now**: the decisions in force and their *why* (expensive to reconstruct later), stage boundaries, ordering, and a provisional task chunking per stage.
- **Defer to stage start**: final task slicing, grounded against the codebase as it exists then. `/to-tasks` does that re-grounding when handed a stage brief.

## Process

### 1. Gather context

Work from the conversation — ideally this runs at the end of a planning/grilling session. Read any referenced design or plan documents in full. If the plan's decisions aren't already written down somewhere durable (a design doc, ADRs, CONTEXT.md), get them written first; briefs reference decisions, they shouldn't be the only record of them.

### 2. Define stages

Split the effort into sequential stages. Each stage must be:

- **One feature's worth of work** — a handful of `/to-tasks` tasks, one branch, finished via the project's review process
- **Independently shippable** — the codebase is healthy and the trunk deployable after each stage merges
- **Ordered** — later stages may depend on earlier ones; note genuine cross-stage dependencies in the roadmap index (unlike tasks, stages may be reorderable, and the index should say which)

### 3. Quiz the user

Present the stage list (title + one-line goal each). Ask whether the boundaries and order feel right, and iterate until approved.

### 4. Write the roadmap

Create `docs/roadmaps/<name>/` and write:

- `ROADMAP.md` — the index
- `NN-<slug>.md` — one brief per stage, zero-padded

<roadmap-template>
# <Name> roadmap

<1-2 paragraphs: what this effort realizes, linking the design/plan docs it derives from.>

Each stage is one `/to-tasks` feature (one branch, one review unit). Start the next one with `/next-stage` in a fresh session. Task chunkings inside briefs are provisional — re-grounded against the codebase when the stage starts.

<Dependency notes: which stages are reorderable, which genuinely depend on which.>

## Stages

- [ ] 01: <title> — [brief](01-<slug>.md)
- [ ] 02: <title> — [brief](02-<slug>.md)
- ...
</roadmap-template>

<stage-brief-template>
# NN. <Stage title>

## Goal

<What is demonstrable when this stage is done — end-to-end behavior, not layers.>

## Decisions in force

<The decisions from the planning session that bear on this stage, each with its
why. Reference design docs, ADRs, and CONTEXT.md terms rather than restating
them, but DO restate rationale that lives nowhere else. This section is the
context transfer — it's what makes the stage startable in a fresh session.>

## Proposed tasks (provisional)

<A numbered draft of the /to-tasks breakdown: title + one-line what + 2-3
acceptance-criteria sketches each. Mark clearly as provisional — /to-tasks
re-grounds and re-quizzes at stage start. Same rules as /to-tasks: thin
vertical tracer-bullet slices, no file paths except decision-rich shapes.>

## Re-verify at start

<Bullet list of assumptions likely to have drifted by the time this stage
starts — things /to-tasks must check against the actual codebase before
finalizing the breakdown (e.g. "assumes X still lives in Y", "assumes stage
NN landed first").>
</stage-brief-template>

### 5. Commit

Commit the roadmap directory along with any design docs, ADRs, or CONTEXT.md changes the planning session produced. If a feature branch for the first stage already exists, commit there; otherwise commit wherever the planning docs belong — typically a planning branch or the current feature branch. Committing straight to the default branch is fine only if the project's review process is direct-merge (see the `## Review process` section of `docs/agents/git-workflow.md`); if it uses PRs or another review unit, put the docs on a branch.

Then tell the user:

> Roadmap `<name>` created with N stages under `docs/roadmaps/<name>/`. Run `/next-stage` in a fresh session to start the first stage (or finish the in-flight `.tasks/` feature first).
