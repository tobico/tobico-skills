# tobico-skills

My personal suite of workflow skills for coding agents, distributed as [vercel-labs/skills](https://github.com/vercel-labs/skills).

It's two things in one repo:

- **My own skills** — a plan → tasks → implement loop that keeps an agent working one small, reviewable slice at a time.
- **Vendored skills** — the [Matt Pocock skills](https://github.com/mattpocock/skills) I lean on daily, copied in and pinned so an upstream change can't shift them under me. One (`grilling`) carries local modifications. See [Credits](#credits).

## Install

```
npx skills add tobico/tobico-skills
```

Pick the skills you want from the interactive list. Once installed, invoke them by name: `/grill-me`, `/to-tasks`, `/next-task`, and so on.

> **Note:** the vendored skills keep their original names (`tdd`, `grilling`, `grill-me`, `grill-with-docs`, `domain-modeling`). Install them from *either* this repo *or* `mattpocock/skills`, not both — same names would collide. Installing from here gives you my pinned versions.

## The skills

### Mine

- **`to-tasks`** — Break a plan, spec, PRD, or roadmap stage brief into sequential local task files under `.tasks/`, checked into the repo. Companion to `next-task`.
- **`next-task`** — Pick up and implement the next sequential task from `.tasks/`. TDD-style, with a hard approval gate before commit; deletes the task file on commit and prompts a context clear before the next one.
- **`to-roadmap`** — Convert a large plan into a staged roadmap under `docs/roadmaps/<name>/`, one stage per `to-tasks` feature. For efforts too big for a single task backlog.
- **`next-stage`** — Start the next stage of a roadmap: mark the previous one done and hand the next stage's brief to `to-tasks`.
- **`confirm`** — Pause before writing code to summarise understanding, ask clarifying questions, and get explicit go-ahead. A lightweight gate for one-off asks.
- **`setup-tobico-skills`** — Configure the per-project git workflow these skills rely on (branch naming, review process), stored in `docs/agents/git-workflow.md`.

### Vendored (from [mattpocock/skills](https://github.com/mattpocock/skills))

- **`grill-me`** — A relentless interview to sharpen a plan or design. *(delegates to `grilling`)*
- **`grill-with-docs`** — Same relentless interview, but records ADRs and a glossary as you go. *(delegates to `grilling` + `domain-modeling`)*
- **`grilling`** — The core interview engine. **Locally modified** — see [Credits](#credits).
- **`domain-modeling`** — Build and sharpen a project's domain model, terminology, and ADRs.
- **`tdd`** — Test-driven development (red → green → refactor). Invoked by `next-task`.

## Workflow

The skills chain into one loop: **grill the plan → slice it into tasks → implement one slice at a time, with a fresh context per slice.**

### 1. Grill the plan

Stress-test the plan before any code exists, resolving every open question one at a time:

- `/grill-me` — a relentless interview, no docs written.
- `/grill-with-docs` — the same, but captures decisions as ADRs and a glossary via `/domain-modeling`. Use this when the decisions deserve a durable record.

### 2. (Large efforts) Break into a roadmap

If the work is bigger than a single feature branch:

1. `/to-roadmap` — chunk the plan into sequential stages under `docs/roadmaps/<name>/`, one stage per `to-tasks` feature.
2. `/next-stage` — in a fresh session, start the next stage by handing its brief to `to-tasks`.

### 3. Slice into tasks

- `/to-tasks` — once questions are answered and the agent is ready to implement, create a feature branch and write numbered task files into `.tasks/`.

### 4. Implement, one slice per context

1. `/clear` — start with a fresh context.
2. `/next-task` — implements the next task with TDD (via `/tdd`), stops before commit for your review, then commits and deletes the task file.
3. Repeat 1–2 for each remaining task. Clearing the context between tasks is the whole point — it keeps the agent from getting overwhelmed.

When the last task lands, `next-task` finishes the feature via the project's configured review process.

### Ad-hoc

- `/confirm` — append to any request to make the agent summarise its understanding and stop for your go-ahead before touching code.
- `/setup-tobico-skills` — run once per project to configure branch naming and the review process; `to-tasks` and `next-task` also trigger it on demand.

## Answering questions

Several of these skills ask you questions using a shared labelling grammar, so you can answer tersely and unambiguously — especially on rounds where more than one thing is asked at once. `grilling` uses it throughout an interview; `to-tasks`, `to-roadmap`, `confirm`, `next-task`, `next-stage`, `setup-tobico-skills`, and `domain-modeling` use it whenever they ask.

Questions are labelled `Qn` (monotonic across the session), sub-questions get a letter (`Qna`), and answer options get a `.N` suffix, with the recommendation marked by a `★` on its number (e.g. `Q11.1★`):

```
Q11 — Which framing should the rewritten README take?
      Q11.1★  Personal curated suite
      Q11.2   Distribution-first catalog
      Q11a — Keep the documented install command?
             Q11a.1★  Keep it
             Q11a.2   Change it
      Q11b — Keep the workflow walkthrough section?
             Q11b.1★  Keep it, updated
             Q11b.2   Drop it
```

Reply by keying to the labels:

- `1` — main question, option 1 (`Q11.1`)
- `a.1; b.2` — sub-question a → option 1, sub-question b → option 2
- `1; a.1; b.2` — the main question and both sub-questions at once
- `1 because it reads clearer` — rationale can trail any answer
- `Q11.2` — an explicit label always wins, regardless of context
- `*` — accept every `★` recommendation on the table

Prose is always fine too — you can just answer in words instead of picking an option. The full spec lives in [`QUESTION-GRAMMAR.md`](./QUESTION-GRAMMAR.md); each question-asking skill carries a synced copy (kept in step by `bin/question-grammar.sh`).

## Credits

The five vendored skills (`grill-me`, `grill-with-docs`, `grilling`, `domain-modeling`, `tdd`) originate from [mattpocock/skills](https://github.com/mattpocock/skills), used under the MIT License. They're vendored — copied in and pinned — so upstream changes don't alter my daily workflow; the upstream copies have already diverged from these.

`grilling` is **locally modified**: it uses a labelling and reply grammar for questions, sub-questions, and answer options, so multi-question rounds are easy to answer unambiguously. That grammar has been lifted out of `grilling` into a repo-level [`QUESTION-GRAMMAR.md`](./QUESTION-GRAMMAR.md) and is now reused across the suite (see [Answering questions](#answering-questions)). The rest are copied verbatim.

The exact upstream commit each skill was vendored from is recorded in [`VENDOR.md`](./VENDOR.md).

## License

MIT
