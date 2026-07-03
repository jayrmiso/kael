#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: kael-merge-pr.sh <pr-number-or-url> [base-branch]

Merges a published PR remotely through the GitHub API, then fast-forwards the
local base branch from origin. This is the approved Kael wrapper for projects
that forbid direct `gh pr merge`.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage >&2
  exit 2
fi

pr_target="$1"
base_branch="${2:-main}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required but was not found on PATH" >&2
  exit 127
fi

gh auth status >/dev/null

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
pr_number="$(gh pr view "$pr_target" --json number --jq .number)"
if [[ -z "$pr_number" ]]; then
  echo "could not resolve PR target: $pr_target" >&2
  exit 2
fi

gh pr view "$pr_number" --json number,title,url,headRefName,baseRefName,state,mergeStateStatus
gh api -X PUT "repos/$repo/pulls/$pr_number/merge" -f merge_method=merge

git fetch origin "$base_branch"
git checkout "$base_branch"
git pull --ff-only origin "$base_branch"

gh pr view "$pr_number" --json number,title,url,state,mergedAt,mergeCommit
