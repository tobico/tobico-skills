---
name: setup-tobico-skills
description: Configure the per-project git workflow the tobico skills rely on — branch naming and review process — stored in docs/agents/git-workflow.md. Run it directly to set everything up front, or let /to-tasks and /next-task trigger it on demand when a convention they need isn't configured yet. Use when the user says "set up the skills", "configure branch naming", "configure the review process", or another skill delegates here.
---

# Setup (tobico skills)

Owns the per-project git-workflow conventions the tobico skills read. Everything lives in one committed file, **`docs/agents/git-workflow.md`**, with one section per convention:

- `## Branch naming` — the feature-branch pattern (read by `/to-tasks`)
- `## Review process` — how a finished feature branch is landed (read by `/next-task`)

Sections are filled **on demand**: a section counts as configured only when it has real content, not just a heading.

## Invocation

- **Directly (`/setup-tobico-skills`)** — proactive full setup: walk *every* section, showing the current value where one exists and offering keep-or-change, and write the complete file.
- **Scoped (delegated by another skill)** — configure only the section that skill named (`branch-naming` or `review-process`), then return so the caller continues. This is the normal path; `/to-tasks` and `/next-task` invoke it when their section is missing.

Determine the scope from how you were invoked. If a caller named a section, do only that one. A bare direct invocation does all sections.

## Menus are the only place conventions are chosen

Other skills never prompt for these conventions — they read the file or delegate here. Keep the menus and the canonical section text in this skill only.

Present menus using the question grammar in [`QUESTION-GRAMMAR.md`](./QUESTION-GRAMMAR.md): label each menu `Qn`, its choices as `.N` options with the default marked `★`, and let the user free-type a custom answer.

## Branch naming

The feature-branch pattern is stored as a token string on a `Pattern:` line. Supported tokens:

- `<feature>` — the kebab-case feature name the caller picked (e.g. `credential-storage`)
- `<handle>` — the developer's short handle (see **Handle** below)

Anything else in the pattern is literal text.

### Configure

1. If the section already has a `Pattern:` line and this is a proactive run, show it and ask whether to keep or change it. If keeping, skip to the handle step.
2. Otherwise present the menu (offer these three; the user may free-type a custom pattern):

   - **`<handle>/<feature>`** — e.g. `tobi/credential-storage`
   - **`<feature>`** — bare kebab-case, no prefix
   - **Free text** — a custom pattern using the `<handle>` and `<feature>` tokens (e.g. `feature/<feature>`)

3. Write the chosen pattern into `docs/agents/git-workflow.md` under `## Branch naming`:

        ## Branch naming

        Pattern: `<chosen pattern>`

4. **Handle** — only if the chosen pattern contains the `<handle>` token:
   - Read the per-user handle from `git config --global tobico.handle`.
   - If it's set, nothing to do.
   - If it's unset, ask the user for their handle, offering a default derived from the email local-part (`git config user.email`, the part before `@`). Store the answer:

            git config --global tobico.handle <handle>

     The handle is per-user and lives in global git config — never write it into `git-workflow.md` (that file is committed and shared).

   When invoked scoped and the pattern is *already* configured but the handle is just missing (e.g. a teammate freshly cloned the repo), skip the menu entirely and do only this handle step.

## Review process

Defines how a completed feature branch is finished and landed. Stored under `## Review process` as a `### Finish sequence` (the ordered steps `/next-task` executes) plus a `### Notes` block.

### Configure

1. If the section already has a `### Finish sequence` and this is a proactive run, show it and ask whether to keep or change it.
2. Otherwise present the menu (offer these three; the user may free-type a custom process, e.g. Bitbucket):

   - **GitHub PR** — push the branch and open a draft PR.
   - **None** — merge the finished branch directly to the default branch.
   - **Free text** — the user describes their own process.

3. Write the chosen finish steps into `docs/agents/git-workflow.md`. `/next-task` executes these steps verbatim, supplying dynamic context (feature name, completed-task summary, roadmap stage) when a step opens a PR.

   For **GitHub PR**, write:

        ## Review process

        ### Finish sequence

        1. Push the current feature branch to origin.
        2. Open a **draft** PR (`gh pr create --draft`). Title = feature name;
           body = summary of the completed tasks (name the stage and roadmap if
           this was a roadmap stage). Return the PR URL.

        ### Notes

        - Default branch: <detected default, e.g. main>
        - PRs open as draft. Change "draft" to "ready" here to open ready-for-review.

   For **None (direct merge)**, write:

        ## Review process

        ### Finish sequence

        Land the feature branch on the default branch, then delete it locally
        (never push the feature branch in this mode):

            default=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')
            default=${default:-main}
            feature=$(git branch --show-current)
            git switch "$default"
            git merge --no-ff "$feature"
            git push               # only if a remote exists
            git branch -d "$feature"

        ### Notes

        - Default branch: <detected default, e.g. main>
        - No PR is opened; work lands straight on the default branch.

   For **Free text**, capture the user's description as ordered steps under `### Finish sequence`, and record anything the agent should know (base branch, forge CLI quirks) under `### Notes`.

## Creating the file

`docs/agents/git-workflow.md` may not exist yet. When writing a section, create the file (and `docs/agents/`) if needed, starting from:

    # Git workflow

Then add only the section(s) in scope. A proactive run produces both sections; a scoped run adds just its own, leaving the other for whenever its skill needs it.

## Committing

Don't commit on a scoped run — the calling skill folds `git-workflow.md` into its own commit (`/to-tasks`'s plan commit, `/next-task`'s finish commit). On a proactive direct run, tell the user the file was written and let them commit it where they see fit; don't commit it yourself unless asked.

## Tips

- The handle lives in global git config, the pattern and review process live in the committed file. Keep per-user and per-project state separate.
- Never guess a convention silently — if a needed section is missing, ask via the menu. That's the whole point of this skill.
