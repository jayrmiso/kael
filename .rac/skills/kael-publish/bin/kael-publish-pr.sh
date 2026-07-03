#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: kael-publish-pr.sh <base-branch> <title> <body-file>

Pushes the current Kael implementation branch, then creates a normal GitHub PR.
Run this from the finished Kael implementation worktree. If .kael/handoff.md is
dirty, the wrapper commits it before pushing so the handoff is part of the PR.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 3 ]]; then
  usage >&2
  exit 2
fi

base_branch="$1"
title="$2"
body_file="$3"

if [[ ! -f "$body_file" ]]; then
  echo "body file does not exist: $body_file" >&2
  exit 2
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required but was not found on PATH" >&2
  exit 127
fi

gh auth status >/dev/null

current_branch="$(git branch --show-current)"
if [[ -z "$current_branch" ]]; then
  echo "not on a named git branch" >&2
  exit 2
fi

default_branch="$(git remote show origin 2>/dev/null | sed -n '/HEAD branch/s/.*: //p' | head -n 1 || true)"
if [[ "$current_branch" == "main" || "$current_branch" == "master" || ( -n "$default_branch" && "$current_branch" == "$default_branch" ) ]]; then
  echo "refusing to publish from protected branch: $current_branch" >&2
  exit 2
fi

if [[ -n "$(git status --porcelain -- .kael/handoff.md)" ]]; then
  git add .kael/handoff.md
fi

worktree_artifact_paths=()
while IFS= read -r status_line; do
  [[ -z "$status_line" ]] && continue
  status_code="${status_line:0:2}"
  path="${status_line:3}"
  [[ "$path" == \"*\" ]] && path="${path#\"}" && path="${path%\"}"
  if [[ "$status_code" == " D" || "$status_code" == "D " || "$status_code" == "D" ]]; then
    mode="$(git ls-files --stage -- "$path" | awk '{print $1}')"
    if [[ "$mode" == "160000" ]]; then
      worktree_artifact_paths+=("$path")
    fi
  fi
done < <(git status --porcelain -- .kael/worktrees)

if [[ "${#worktree_artifact_paths[@]}" -gt 0 ]]; then
  git add -u -- "${worktree_artifact_paths[@]}"
fi

if ! git diff --cached --quiet -- .kael/handoff.md .kael/worktrees; then
  git commit -m "docs(kael): update implementation handoff"
fi

dirty_after_handoff="$(git status --porcelain)"
if [[ -n "$dirty_after_handoff" ]]; then
  echo "refusing to publish with uncommitted changes outside the Kael handoff:" >&2
  echo "$dirty_after_handoff" >&2
  exit 2
fi

git push -u origin "$current_branch"
gh pr create --base "$base_branch" --head "$current_branch" --title "$title" --body-file "$body_file"
