#!/usr/bin/env bash
#
# Keep each question-asking skill's QUESTION-GRAMMAR.md in sync with the
# repository canonical at ./QUESTION-GRAMMAR.md.
#
#   bin/question-grammar.sh sync    Regenerate every per-skill copy from the canonical.
#   bin/question-grammar.sh check   Exit non-zero if any copy is missing or has drifted.
#
# The single source of truth is the canonical's body (everything after its
# leading HTML comment). Each copy is that body under a "generated copy" banner.
# Edit the canonical, then run `sync`. `check` is safe to wire into a hook or CI.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CANONICAL="$ROOT/QUESTION-GRAMMAR.md"

# Skills that ask the user questions and therefore carry a copy of the grammar.
# Deliberately excludes pure delegators (grill-me, grill-with-docs) and skills
# that don't quiz (tdd).
SKILLS=(
  confirm
  domain-modeling
  grilling
  next-stage
  next-task
  setup-tobico-skills
  to-roadmap
  to-tasks
)

BANNER='<!--
Generated copy of the repository canonical QUESTION-GRAMMAR.md.
Do not edit here — edit /QUESTION-GRAMMAR.md at the repo root and run
`bin/question-grammar.sh sync`. `bin/question-grammar.sh check` fails on drift.
-->'

# Strip the canonical's leading HTML comment header and any blank lines after it.
extract_body() {
  awk '
    NR==1 && /^<!--/ { h=1; next }
    h { if (/-->/) h=0; next }
    !p && /^[[:space:]]*$/ { next }
    { p=1; print }
  ' "$CANONICAL"
}

# The exact content a per-skill copy should have.
render_copy() {
  printf '%s\n\n%s\n' "$BANNER" "$(extract_body)"
}

copy_path() { printf '%s/skills/%s/QUESTION-GRAMMAR.md' "$ROOT" "$1"; }

cmd_sync() {
  local content skill dest
  content="$(render_copy)"
  for skill in "${SKILLS[@]}"; do
    dest="$(copy_path "$skill")"
    printf '%s\n' "$content" > "$dest"
    echo "synced $dest"
  done
}

cmd_check() {
  local content skill dest drift=0
  content="$(render_copy)"
  for skill in "${SKILLS[@]}"; do
    dest="$(copy_path "$skill")"
    if [[ ! -f "$dest" ]]; then
      echo "MISSING $dest"
      drift=1
    elif ! printf '%s\n' "$content" | diff -q - "$dest" >/dev/null; then
      echo "DRIFTED $dest"
      drift=1
    fi
  done
  if [[ "$drift" -ne 0 ]]; then
    echo "Copies are out of date. Run: bin/question-grammar.sh sync" >&2
    exit 1
  fi
  echo "all ${#SKILLS[@]} copies match the canonical"
}

case "${1:-}" in
  sync)  cmd_sync ;;
  check) cmd_check ;;
  *) echo "usage: $0 {sync|check}" >&2; exit 2 ;;
esac
