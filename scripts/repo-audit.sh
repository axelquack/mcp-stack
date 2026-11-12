#!/usr/bin/env bash
# Read-only report of the standard files. Exit 1 when a required file is missing.
# A gitignored HANDOFF.md counts as present for a public repository.
# The gitleaks workflow is reported and does not fail a private repository.

set -euo pipefail

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "repo-audit: not inside a git repository." >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

missing=0

report() {
  printf '%-12s %s\n' "$1" "$2"
  if [[ "$1" == "MISSING" ]]; then
    missing=1
  fi
}

need_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    report "ok" "$path"
  else
    report "MISSING" "$path"
  fi
}

need_dir() {
  local path="$1"
  if [[ -d "$path" ]]; then
    report "ok" "$path/"
  else
    report "MISSING" "$path/"
  fi
}

echo "repo-audit: standard files in $root"

need_file README.md
need_file AGENTS.md

if [[ -L CLAUDE.md ]]; then
  target="$(readlink CLAUDE.md)"
  if [[ "$target" == "AGENTS.md" ]]; then
    report "ok" "CLAUDE.md -> AGENTS.md"
  else
    report "MISSING" "CLAUDE.md -> AGENTS.md (link target is $target)"
  fi
else
  report "MISSING" "CLAUDE.md -> AGENTS.md"
fi

need_file CHANGELOG.md
need_file ROADMAP.md
need_file TODO.md
need_file BUGFIXES.md
need_file SECURITY.md
need_file LICENSE
need_file justfile
need_dir docs
need_file .env.example
need_file .githooks/pre-commit
need_file scripts/check-secrets.sh
need_file .gitleaks.toml

if git check-ignore -q HANDOFF.md 2>/dev/null; then
  report "ok" "HANDOFF.md (gitignored; public handoff lives in agent-platform)"
elif [[ -f HANDOFF.md ]]; then
  report "ok" "HANDOFF.md"
else
  report "MISSING" "HANDOFF.md"
fi

if [[ -f .github/workflows/gitleaks.yml ]]; then
  report "ok" ".github/workflows/gitleaks.yml"
else
  report "note" ".github/workflows/gitleaks.yml (add this on a public repository)"
fi

if [[ "$missing" -ne 0 ]]; then
  echo "repo-audit: required files are missing." >&2
  exit 1
fi

echo "repo-audit: required files are present."
exit 0
