+++
description = "Kael PR merge workflow: merge a published PR remotely, sync local main, and clean up afterward. Use when the user wants to merge a published Kael PR."

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
- Never bypass repo rules. Use `gh` to merge the PR remotely, then sync local
  `main`.
- Preserve the implementation handoff and final report content.

## Merge Sequence

1. Confirm `gh auth status` succeeds.
2. Resolve the PR number or URL from the user. Only list open PRs if the target
   is ambiguous.
3. Use `gh pr view` once to confirm the PR title, head branch, and merge target.
4. Merge the PR on GitHub with `gh api -X PUT repos/<owner>/<repo>/pulls/<number>/merge -f merge_method=merge` or the repo's equivalent `gh` merge command.
5. Fetch origin and sync local `main` to the merged remote state.
6. Confirm the PR is merged.
7. Delete the local feature branch only if it is safe and no longer needed.

## Output

Return this structure:

```text
Status:
PR:
  URL:
  Number:
  Title:
Merge:
  Command:
  Result:
Sync:
  Command:
  Result:
Cleanup:
Notes:
```

Use `none` only when a field truly does not apply.
