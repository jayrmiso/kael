+++
description = "Kael PR merge workflow: inspect an existing PR, ask which one to merge when ambiguous, write a changelog entry with the exact date, merged commits, and change summary, merge it to main, commit and push the changelog directly to main, and clean up the local worktree afterward. Use when the user wants to merge a published Kael PR."

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
- Never merge `main`, `master`, or the default branch directly until the PR is
  selected and the workflow is ready to update `main`.
- Never approve, close, or reopen PRs unless the selected workflow requires it.
- Never delete the worktree before the merge result is captured.
- Never bypass repo rules. Use `gh` CLI for selection, inspection, and merge
  operations, then use git to update `main` and push the changelog commit when
  the workflow requires it.
- Append a changelog entry before merging. Prefer the repo's existing changelog
  file; otherwise create `changelog.md`.
- The changelog entry must record the exact date, PR number/title, merged commit
  hashes, touched files or modules when available, and a short summary of what
  changed.
- Preserve the implementation handoff and final report content.

## Merge Sequence

1. Confirm `gh auth status` succeeds.
2. List open PRs if the user did not provide a unique PR number or URL.
3. Ask a blocking question if more than one PR matches the request.
4. Inspect the selected PR with `gh pr view`.
5. If a local checkout is needed, use `gh pr checkout` or the existing worktree.
6. Merge the checked-out PR branch into `main` with `git merge`, using `gh`
   only for PR selection, inspection, and checkout.
7. Switch to `main` if needed, then append a changelog entry with the current
   date, merged commit hashes, PR number/title, touched files or modules when
   available, and a one-line summary of what changed.
8. Commit the changelog update on `main`.
9. Push `main` so the changelog update is published.
10. Confirm the PR is merged and record the merge URL or number.
11. Clean up the local worktree afterward.
12. Delete the local feature branch only if it is safe and no longer needed.

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
