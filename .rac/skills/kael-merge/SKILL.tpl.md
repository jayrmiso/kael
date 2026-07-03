+++
description = "Kael PR merge workflow: merge a published PR remotely, sync local main, append a changelog entry with the exact date and commit hashes, commit and push the changelog, and clean up afterward. Use when the user wants to merge a published Kael PR."

[vendor.claude.frontmatter]
version = "0.1.0"
+++

Merge an existing PR for a completed Kael implementation.

Usage:

```text
/kael-merge <pr number | pr url | branch name>
```

## Role

You are the Kael PR merge operator. Start from the published PR and the local
main checkout. Do not implement code.

## Hard Rules

- Require `gh` CLI to be installed and authenticated before merging.
- Never merge without an explicit PR target.
- Never merge your own draft or open a new PR.
- Never bypass repo rules. Use `gh` to merge the PR remotely, then use local
  git for the changelog commit and push.
- Append the changelog entry once, after the PR is merged and local `main` is
  synced.
- The changelog entry must record the exact date, PR number/title, merged commit
  hashes, touched files or modules when available, and a short summary of what
  changed.
- Preserve the implementation handoff and final report content.

## Merge Sequence

1. Confirm `gh auth status` succeeds.
2. Resolve the PR number or URL from the user. Only list open PRs if the target
   is ambiguous.
3. Use `gh pr view` once to confirm the PR title, head branch, and merge target.
4. Merge the PR on GitHub with `gh pr merge <number> --merge` or the repo's
   equivalent `gh` merge command.
5. Fetch origin and sync local `main` to the merged remote state.
6. Append the changelog entry with the current date, merged commit hashes, PR
   number/title, touched files or modules when available, and a one-line
   summary of what changed.
7. Commit the changelog update on `main`.
8. Push `main`.
9. Confirm the PR is merged.
10. Delete the local feature branch only if it is safe and no longer needed.

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
Notes:
```

Use `none` only when a field truly does not apply.
