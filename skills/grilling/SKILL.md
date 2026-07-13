---
name: grilling
description: Grill the user relentlessly about a plan or design. Use when the user wants to stress-test a plan before building, or uses any 'grill' trigger phrases.
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask questions one at a time, waiting for feedback before continuing — asking many at once is bewildering. Only ask more than one in a single message when the decisions genuinely can't be resolved in sequence. When you must, use the labelling and reply grammar below so every answer keys unambiguously back to its question.

If a question can be answered by exploring the codebase, explore the codebase instead.

Do not enact the plan until I confirm we have reached a shared understanding.

## Question labels

- **Questions** are numbered `Q1`, `Q2`, … **monotonically across the whole session** — never reset the counter per message, so `Q4` always refers to the same question when either of us points back to it.
- **Sub-questions** append a letter: `Q7a`, `Q7b`. Use these when one question has distinct parts that each need their own answer.
- **Answer options** append `.N`: a main question's options are `Q7.1`, `Q7.2`; a sub-question's are `Q7a.1`, `Q7a.2`. Mark your recommended option with `★`.
- A question node **may carry both its own options and sub-questions**. There's no ambiguity because main-level answers are always bare numbers and sub-level answers always carry a letter prefix (see the reply grammar).
- **Two levels maximum.** A sub-question is always a leaf — it carries answer options, it never branches into further sub-questions. If a decision feels deeper than that, split it into separate top-level questions instead.

Example of a mixed node:

```
Q11 — Which framing should the rewritten README take?
      Q11.1  Personal curated suite   ★
      Q11.2  Distribution-first catalog
      Q11a — Keep the documented install command?
             Q11a.1  Keep it   ★
             Q11a.2  Change it
      Q11b — Keep the workflow walkthrough section?
             Q11b.1  Keep it, updated   ★
             Q11b.2  Drop it
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
