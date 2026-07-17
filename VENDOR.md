# Vendored skills

These skills are copied ("vendored") into this repo from [mattpocock/skills](https://github.com/mattpocock/skills)
so that upstream changes don't alter my daily workflow. The upstream copies have already diverged from what's
recorded here.

Source: `https://github.com/mattpocock/skills.git` (MIT License).

The hash below is the `skillFolderHash` recorded by the [`skills`](https://github.com/vercel-labs/skills) CLI
in `.skill-lock.json` at the time each skill was installed — it identifies the exact upstream folder contents
this copy was taken from, and serves as the diff anchor if I ever reconcile against a newer upstream version.

| Skill | Upstream path | Vendored folder hash | Modified? |
|---|---|---|---|
| `tdd` | `skills/engineering/tdd/` | `57e1bee887816ed2af745e5fd388f224f6e61ada` | verbatim |
| `grilling` | `skills/productivity/grilling/` | `8b14ca97479f518f3f1ced6a35bf591554d7e0cb` | **modified** — uses the question/reply labelling grammar, now extracted to the repo-level `QUESTION-GRAMMAR.md` and referenced via a synced copy; also replaces the upstream "one question at a time" pacing with the grammar's complexity-budget pacing (batch independent questions per turn) |
| `grill-me` | `skills/productivity/grill-me/` | `8320e7b87f7b208f50ce165b1dd43d1e93c8e801` | verbatim |
| `grill-with-docs` | `skills/engineering/grill-with-docs/` | `21adba95de7d93065d9fec725ddf37f871e01d05` | verbatim |
| `domain-modeling` | `skills/engineering/domain-modeling/` | `028a0e44b23909cbdd715aa00546d5c1c46ae4d6` | **modified** — references the shared `QUESTION-GRAMMAR.md` (synced copy) when asking questions |

## Updating a vendored skill from upstream

1. Fetch the current upstream folder for the skill from `mattpocock/skills`.
2. Diff it against the vendored copy here to see what changed upstream.
3. Re-apply any local modifications (currently `grilling` and `domain-modeling`) on top of the new upstream content. Both carry a synced `QUESTION-GRAMMAR.md` copy — after any change to the shared grammar, run `bin/question-grammar.sh sync`.
4. Update the folder hash in the table above to the new upstream version.
