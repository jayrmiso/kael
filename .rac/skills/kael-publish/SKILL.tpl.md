+++
description = "Kael PR publication workflow: create a normal PR from the current Kael implementation branch with GitHub CLI, let gh handle publishing the branch when needed, and clean up the local worktree afterward. Use when /kael-impl is complete and the user asks to open a PR, publish the branch, or clean up the finished worktree."

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
- Never bypass repo push rules. Use one `gh pr create` from the current branch
  and let gh handle the publish prompt when the branch is not yet on a remote.
- Do not pass `--head` for a local unpublished branch.
- Do not pre-publish the branch manually with `git push`.
- Do not create branch refs with the GitHub git refs API.
- Do not search for wrapper commands before trying the direct `gh pr create`
  flow.
- Preserve the implementation handoff and final report content.

## Publish Sequence

1. Confirm the branch, worktree path, and base branch.
2. Confirm `gh auth status` succeeds.
3. Build the PR title and body from the final implementation report and handoff.
4. Open the PR from the current branch with `gh pr create --base <base-branch> --title "<title>" --body "<body>"`.
5. If gh prompts where to push the branch, accept the repository remote.
6. Capture the PR URL from the `gh` output.
7. Clean up the local worktree after the PR exists.
8. Delete the local feature branch only if it is safe and no longer needed.

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
Cleanup:
  Worktree:
  Branch:
  Result:
Notes:
```

Use `none` only when a field truly does not apply.
