<!--
Source of truth for the question-asking grammar shared across the tobico skills.
Per-skill copies (each skill's own QUESTION-GRAMMAR.md) are generated from this
file by bin/question-grammar.sh — edit HERE, not the copies, then run
`bin/question-grammar.sh sync`. `bin/question-grammar.sh check` fails if any copy
has drifted.
-->

# Question grammar

When you ask the user questions, label them so every answer keys unambiguously
back to its question. Not every question has options — a bare clarifying
question just gets a `Qn` label; add `.N` options only when there are discrete
choices. When there are, provide a recommended answer.

## Question labels

- **Questions** are numbered `Q1`, `Q2`, … **monotonically across the whole session** — never reset the counter per message, so `Q4` always refers to the same question when either of us points back to it.
- **Sub-questions** append a letter: `Q7a`, `Q7b`. Use these when one question has distinct parts that each need their own answer.
- **Answer options** append `.N`: a main question's options are `Q7.1`, `Q7.2`; a sub-question's are `Q7a.1`, `Q7a.2`. Mark your recommended option by appending `★` directly to its number, e.g. `Q7.1★`.
- A question node **may carry both its own options and sub-questions**. There's no ambiguity because main-level answers are always bare numbers and sub-level answers always carry a letter prefix (see the reply grammar).
- **Two levels maximum.** A sub-question is always a leaf — it carries answer options, it never branches into further sub-questions. If a decision feels deeper than that, split it into separate top-level questions instead.

Example of a mixed node:

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

## How I reply

- **Bare number** → the **main** question's option: `1` picks `Q11.1`; `1 because it's clearer` adds rationale.
- **Letter + number** → a **sub-question's** option: `a.1; b.2` picks `Q11a.1` and `Q11b.2`.
- **Combine freely** with `;`: `1; a.1; b.2` answers the main question and both sub-questions at once.
- **`*`** → accept every `★` recommendation on the table (main question and all sub-questions).
- **Explicit labels always win** — if I write `Q11.2`, honour that verbatim regardless of what's "current".
- **Prose is always valid** — not every question has options; I may just answer in words, or give my own answer instead of picking one.

Rules that keep this unambiguous:

- The bare/letter shorthand infers the question from context **only when a single top-level question is on the table**. If you've asked more than one top-level question at once, a bare token is invalid — ask me to prefix each answer with its `Qn` label. (`*` is the one exception: it always means "accept all recommendations".)
- If I answer some parts of a question but not others (and don't use `*`), treat the unaddressed main-question or sub-questions as **still open** — ask a brief follow-up. Never silently assume I accepted the recommendation for something I didn't mention.
