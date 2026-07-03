+++
description = "Kael PR publication workflow: commit the Kael handoff when needed, push the current implementation branch through the approved Kael wrapper, create a normal PR with GitHub CLI, and clean up the local worktree afterward. Use when /kael-impl is complete and the user asks to open a PR, publish the branch, or clean up the finished worktree."

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
- Never bypass repo push rules. Use the installed Kael publish wrapper from the
  current branch; the wrapper is the approved path for committing handoff,
  pushing the feature branch, and opening the PR.
- Do not run direct `git push`; the wrapper is the approved publish path.
- Do not run direct `gh pr create` unless the installed wrapper file is missing.
- Do not manually pre-publish the branch outside the wrapper.
- Do not create branch refs with the GitHub git refs API.
- Do not search for wrapper commands; Kael ships its own wrapper at the
  installed skill asset path.
- Preserve the implementation handoff and final report content.
- If `.kael/handoff.md` is dirty, the wrapper must commit it before pushing so
  the handoff is part of the PR branch.

## Publish Sequence

1. Confirm the branch, worktree path, and base branch.
2. Confirm `gh auth status` succeeds.
3. Build the PR title and body from the final implementation report and handoff.
4. Write the PR body to a temp file.
5. Commit any dirty `.kael/handoff.md`, push the current branch, and open the PR
   with the installed wrapper:
   `.agents/skills/kael-publish/bin/kael-publish-pr.sh <base-branch> "<title>" <body-file>`.
   If the target is Claude or OpenCode and that path does not exist, use the
   equivalent installed skill asset path under `.claude/skills/kael-publish/bin`
   or `.opencode/skills/kael-publish/bin`.
6. Capture the PR URL from the wrapper output.
7. Clean up the local worktree after the PR exists.
8. Delete the local feature branch only if it is safe and no longer needed.

## Cleanup Rules

- Remove the worktree only after the PR URL is known.
- If the worktree is dirty beyond `.kael/handoff.md`, stop and report blocked
  publish/cleanup.
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
