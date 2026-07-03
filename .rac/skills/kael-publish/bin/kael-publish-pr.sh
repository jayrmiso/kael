#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: kael-publish-pr.sh <base-branch> <title> <body-file>

Creates a normal GitHub PR from the current branch. Run this from the finished
Kael implementation worktree. The script intentionally does not accept --head:
gh should publish the current branch to the repository remote when prompted.
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

gh pr create --base "$base_branch" --title "$title" --body-file "$body_file"
