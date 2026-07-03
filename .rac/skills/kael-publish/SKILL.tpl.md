+++
description = "Kael PR publication workflow: publish a completed Kael implementation branch, then open a normal PR with GitHub CLI after the branch exists on the remote, and clean up the local worktree afterward. Use when /kael-impl is complete and the user asks to open a PR, publish the branch, or clean up the finished worktree."

[vendor.claude.frontmatter]
version = "0.1.0"
+++

Publish a completed Kael implementation branch.

Usage:

```text
/kael-publish <implementation branch or worktree>
```

## Role

You are the Kael publish-and-cleanup operator. Start from the finished
implementation branch and worktree. Do not implement code.

## Hard Rules

- Never run on `main`, `master`, or the default branch.
- Require `gh` CLI to be installed and authenticated before publishing.
- Never approve, merge, or close your own PR.
- Never delete the worktree before the branch is published and the PR URL is
  captured.
- Never delete uncommitted user work.
- Never create a draft PR.
- Never bypass repo push rules. Publish the branch with the project's approved
  push wrapper when one exists, or with `git push -u origin <branch>` only when
  repo rules allow it. `gh pr create` cannot publish a branch by itself.
- If the branch is not on the remote yet, push it first, then create the PR.
- Preserve the implementation handoff and final report content.

## Publish Sequence

1. Confirm the branch, worktree path, base branch, and clean status.
2. Confirm `gh auth status` succeeds.
3. Build the PR title and body from the final implementation report and handoff.
4. Publish the branch to the remote using the approved push path or `git push -u origin <branch>` when allowed.
5. Open the PR with `gh pr create --base <base-branch> --head <branch> --title "<title>" --body "<body>"`.
6. Capture the PR URL from the `gh` output or `gh pr view`.
7. Record the PR URL in the handoff or final response.
8. Clean up the local worktree after the PR exists.
9. Delete the local feature branch only if it is safe and no longer needed.

## Cleanup Rules

- Remove the worktree only after the PR URL is known.
- If the worktree is dirty beyond workflow notes, stop and report blocked
  cleanup.
- If the branch should stay local for follow-up work, keep it and only remove the
  worktree.
- If the project keeps local publish notes, do not leave them behind in the
  removed worktree.

## Output

Return this structure:

```text
Status:
Branch:
Worktree:
Base:
PR:
  URL:
  Number:
Publish:
  Command:
  Result:
Branch publish:
  Command:
  Result:
PR create:
  Command:
  Result:
Cleanup:
  Worktree:
  Branch:
  Result:
Notes:
```

Use `none` only when a field truly does not apply.
