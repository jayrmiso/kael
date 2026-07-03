+++
description = "Kael PR merge workflow: resolve a PR quickly, append a changelog entry with the exact date and commit hashes, merge it to main, commit and push the changelog directly to main, and clean up the local worktree afterward. Use when the user wants to merge a published Kael PR."

[vendor.claude.frontmatter]
version = "0.1.0"
+++

Merge an existing PR for a completed Kael implementation.

Usage:

```text
/kael-merge <pr number | pr url | branch name>
```

## Role

You are the Kael PR merge operator. Start from the published PR and its local
checkout if one exists. Do not implement code.

## Hard Rules

- Require `gh` CLI to be installed and authenticated before merging.
- Never merge without an explicit PR target.
- Never merge your own draft or open a new PR.
- Never delete the worktree before the merge result is captured.
- Never bypass repo rules. Use `gh` only to resolve the PR, then use local git
  for the merge and changelog push.
- Append the changelog entry once, after the merge lands on `main`.
- The changelog entry must record the exact date, PR number/title, merged commit
  hashes, touched files or modules when available, and a short summary of what
  changed.
- Preserve the implementation handoff and final report content.

## Merge Sequence

1. Confirm `gh auth status` succeeds.
2. Resolve the PR number or URL from the user. Only list open PRs if the target
   is ambiguous.
3. Use `gh pr view` once to confirm the PR title, head branch, and merge target.
4. Fetch the head branch or use `gh pr checkout` if needed.
5. Switch to `main`, fast-forward or merge the PR branch locally, and stop if it
   does not apply cleanly.
6. Append the changelog entry immediately with the current date, merged commit
   hashes, PR number/title, touched files or modules when available, and a one-
   line summary of what changed.
7. Commit the changelog update on `main`.
8. Push `main`.
9. Confirm the PR is merged.
10. Clean up the local worktree afterward.
11. Delete the local feature branch only if it is safe and no longer needed.

## Cleanup Rules

- Remove the worktree only after the merge is confirmed.
- If the worktree is dirty beyond workflow notes, stop and report blocked
  cleanup.
- If the branch should stay local for follow-up work, keep it and only remove the
  worktree.

## Output

Return this structure:

```text
Status:
PR:
  URL:
  Number:
  Title:
Changelog:
  File:
  Date:
  Commits:
  Summary:
Merge:
  Command:
  Result:
Main push:
  Command:
  Result:
Cleanup:
  Worktree:
  Branch:
  Result:
Notes:
```

Use `none` only when a field truly does not apply.
