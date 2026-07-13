---
name: next-task
description: Pick up and implement the next sequential task from .tasks/. TDD-style with a hard approval gate before commit; deletes the task file on commit and prompts the user to clear the context before the next task. When the final task is completed, prompts the user to finish the feature via the project's review process instead. Use when user says "next task", "work on the next one", or "start the next task".
---

# Next Task

Implement the next sequential task from a local plan created by `/to-tasks`.

The most important thing this skill enforces: **one task per context window**. After each task is committed, stop and prompt the user to clear the context before continuing.

`.tasks/` holds one feature's plan at a time.

## Workflow

### 1. Find the next task

Look in `.tasks/`. The "next task" is the **lowest-numbered `NN-*.md` file that still exists** (excluding `TODO.md`).

If no numbered task files remain, the feature is already done — a previous session must have skipped the finish gate. Jump straight to **step 8 (finish gate)** to clean up and finish the feature.

### 2. Read the task

Assume the feature branch is already checked out (created by `/to-tasks` when the plan was made). Don't create or switch branches.

Read the full task file. Summarise the goal in 2-3 sentences before writing any code. Note the acceptance criteria — they define "done".

If the task is genuinely vague, ask ONE clarifying question before starting. Don't over-engineer based on assumptions.

### 3. Implement

Work through the task using `/tdd` (red → green → refactor) when tests are appropriate. Keep scope tight — implement exactly what this task's acceptance criteria describe, nothing more.

When the acceptance criteria are met, **stop and go to step 4**. Do not proceed to commit.

### 4. ⛔ APPROVAL GATE — STOP BEFORE COMMITTING

> This is a hard stop. Do **not** run `git commit` or any step below this line until the user has explicitly said to proceed.

1. Summarise what was done (files changed, tests added, behaviour delivered, criteria met).
2. Ask: **"OK to proceed with the commit, or are changes needed first?"**
3. Wait for the response before doing anything else.
4. If changes are requested, make them and return to step 4.2.
5. Only move to step 5 once the user's answer is an explicit approval.

### 5. Commit

Delete the task file, check off the entry in `TODO.md`, then commit both alongside the code changes:

    rm .tasks/NN-<slug>.md
    # edit .tasks/TODO.md to change "- [ ] NN: ..." to "- [x] NN: ..."
    git add -A
    git commit -m "<type>: <task summary>

    Co-Authored-By: Claude <noreply@anthropic.com>"

Choose a conventional-commit type (`feat`, `fix`, `refactor`, `test`, `docs`, `chore`).

### 6. Check if this was the last task

After the commit succeeds, look in `.tasks/` for any remaining `NN-*.md` files (excluding `TODO.md`).

- **If numbered task files remain:** go to step 7 (context-clear gate).
- **If none remain:** the feature is done — go to step 8 (finish gate) instead.

### 7. ⛔ CONTEXT-CLEAR GATE — STOP HERE

Tell the user:

> Task NN complete and committed. **Clear the context now** (`/clear`) before starting the next task — this is the whole point of the workflow. Then run `/next-task` in a fresh session.

**Do NOT proceed to the next task in the same conversation**, even if the user asks. Politely remind them to clear the context first. The one-task-per-context rule is the reason this skill exists.

### 8. ⛔ FINISH GATE — LAST TASK DONE

This was the final task. Do **not** run the cleanup or finish the feature until the user has explicitly approved.

1. Check `.tasks/TODO.md` for a `Roadmap stage:` line. If present, this feature is a roadmap stage (see `/to-roadmap`): resolve the linked brief's roadmap (`ROADMAP.md` in the same directory) — the finish commit will mark that stage's entry `[x]` and drop its in-progress annotation.
2. **Resolve the review process.** Read `docs/agents/review-process.md`:
   - **If it exists**, its `## Finish sequence` section defines how this feature is landed. Use it in step 7.
   - **If it's missing**, ask the user which process this project uses, offering three choices:
     - **GitHub PR** — push the branch and open a draft PR.
     - **None** — merge the finished branch directly to the default branch.
     - **Free text** — the user describes their own process (e.g. Bitbucket).

     Then create `docs/agents/review-process.md` from the `<review-process-template>` below, writing the chosen finish sequence into it. The new file is committed as part of the finish commit in step 6.
3. Tell the user the feature plan is complete and list what's about to happen:
   - Delete `.tasks/TODO.md` and the `.tasks/` directory.
   - If this was a roadmap stage: mark the stage complete in its `ROADMAP.md`.
   - Create a `chore: finish <feature-name>` commit (including `docs/agents/review-process.md` if it was just created).
   - Run the project's finish sequence (from `review-process.md`).
4. Ask: **"OK to finish up and land this via `<review process>`, or hold off?"**
5. Wait for explicit approval before continuing.
6. On approval, mark the roadmap stage complete (if applicable), then run the cleanup commit:

        # if a roadmap stage: edit docs/roadmaps/<name>/ROADMAP.md —
        # "- [ ] NN: ... *(in progress ...)*" → "- [x] NN: ..."
        git rm .tasks/TODO.md
        rmdir .tasks
        git add -A          # also stages docs/agents/review-process.md if newly created
        git commit -m "chore: finish <feature-name>"

7. Run the project's **finish sequence** from `docs/agents/review-process.md`. The two built-in sequences:

   - **GitHub PR**: push the branch and open a **draft** PR (`gh pr create --draft`). Use the feature name for the title and summarise the completed tasks in the body; if this was a roadmap stage, name the stage and roadmap. Return the PR URL to the user.
   - **None (direct merge)**: land the branch on the repo's default branch, then delete it locally (never push the feature branch in this mode):

            default=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')
            default=${default:-main}
            feature=$(git branch --show-current)
            git switch "$default"
            git merge --no-ff "$feature"
            git push               # only if a remote exists
            git branch -d "$feature"

   For a free-text / custom process, follow the steps written in the file's `## Finish sequence`.

<review-process-template>
# Review process

<!-- How a completed feature branch is finished and landed on this project. -->

## Finish sequence

<Ordered steps the finish gate runs to land a finished feature branch. E.g. for
GitHub: push the branch and open a draft PR via `gh pr create --draft`. For
direct merge: switch to the default branch, `git merge --no-ff` the feature
branch, push (if a remote exists), delete the local feature branch.>

## Notes

<Anything the agent should know: default branch name, draft vs ready-for-review,
forge CLI quirks (e.g. Bitbucket uses a different command), etc.>
</review-process-template>

## Tips

- Never force-push or amend published commits.
- Keep commits atomic — one task per commit.
- The approval gate is a hard stop, even when everything passes and the work feels obviously complete.
- The context-clear gate is also a hard stop. If the user says "just do the next one too", respond that this defeats the workflow and ask them to clear first.
- The finish gate is a hard stop too — never run the cleanup commit or the finish sequence without explicit approval.
