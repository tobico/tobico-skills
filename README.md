# tobico-skills

Three workflow skills, distributed as [vercel-labs/skills](https://github.com/vercel-labs/skills):

- **`to-tasks`** — Break a plan, spec, or PRD into sequential local task files under `.tasks/`, checked into the repo. Companion to `next-task`.
- **`next-task`** — Pick up and implement the next sequential task from `.tasks/`. TDD-style with a hard approval gate before commit.
- **`confirm`** — Pause before writing code to summarize understanding of the task, ask clarifying questions, and get explicit user confirmation.

## Install

```
npx skills add tobico/tobico-skills
```

Pick the skills to install from the interactive list. Once installed, invoke them by name: `/to-tasks`, `/next-task`, `/confirm`.

## Workflow

### Confirm

Gets approval before the agent starts work. Just append `/confirm` to the end of a prompt when you ask the agent to do something — it'll summarise its understanding and stop for your go-ahead before touching any code.

### To-tasks

Breaks a large, complex feature down into smaller independent tasks that can each be worked on in a fresh context:

1. `/grill-with-docs` — Matt Pocock's skill from [mattpocock/skills](https://github.com/mattpocock/skills). Grill your plan against the project's domain model and documentation until every open question is resolved.
2. `/to-tasks` — once all questions are answered and the agent is ready to implement, invoke this to create a feature branch and write numbered task files into `.tasks/`.
3. `/clear` — start with a fresh context.
4. `/next-task` — implements task 01 with TDD, stops before commit for your review, then commits and deletes the task file.
5. Repeat 3 and 4 for each remaining task.

## License

MIT
