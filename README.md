# Kael Spec

Kael Spec is a lightweight RAC pack for plan-first AI-assisted repo work.

It keeps the useful parts of Stride and Zuggie while staying intentionally
small:

- `/kael-spec` as the planning entrypoint
- `/kael-impl` as the approved-plan implementation entrypoint
- mandatory compact plan mode before implementation
- explicit architecture / module layout for multi-boundary work
- protected non-main implementation branch/worktree
- conventional commit messages for completed implementation scopes
- manual test handoff from the implementation worktree
- separate PR publication that commits the Kael handoff, pushes the feature
  branch, and creates a PR through `/kael-publish`
- PR merge workflow that merges the PR on GitHub and syncs local `main`
- approved Kael wrapper scripts for publish/merge so RAC starter deny rules do
  not leave the workflow blocked
- explicit builder assignment maps in `/kael-spec` when multiple builders are
  useful
- compact milestones
- one or more senior builder workers for independent, non-overlapping code
  milestones
- TDD / Prove-It rules for behavior changes
- senior engineering guidance without forced over-abstraction
- concrete handoff after implementation
- concise committed handoff only; no separate long report
- RAC command rules layered on top of project rules

## Install

From the project where you want to use Kael:

```bash
npx @raniejade/rac init --empty
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.22
npx @raniejade/rac install --targets claude,codex --kind agent,skill,rule
```

Use the latest published Kael release tag in `--ref`. Avoid installing from
`main` for normal projects; release tags keep installs reproducible.

Use `rac init --empty` for a Kael-only setup. If a project already used the
default `rac init`, Kael's installed publish and merge wrapper scripts are the
approved path around the starter rules that deny raw `git push` and
`gh pr merge`.

For Codex only:

```bash
npx @raniejade/rac install --targets codex --kind agent,skill,rule
```

## Usage

```text
/kael-spec fix the broken empty state copy
/kael-impl the approved Kael Spec plan
```

## What Gets Installed

- Codex skill: `.agents/skills/kael-spec/SKILL.md`
- Codex skill: `.agents/skills/kael-impl/SKILL.md`
- Codex agents:
  - `.codex/agents/kael-builder.toml`
- Codex rules:
  - `.codex/rules/kael-guardrails.rules`
- Claude skill and agents under `.claude/`

## Workflow

Kael always plans before code:

| Step | Owner | Output |
| --- | --- | --- |
| Plan | `/kael-spec` | compact spec and milestones |
| Approval | user | explicit approval to implement |
| Build | `/kael-impl` + `kael-builder` | code, tests, self-review; multiple builders only for non-overlapping milestones |
| Handoff | `/kael-impl` | concise committed handoff with manual test command and what to test next |
| Publish / cleanup | `/kael-publish` | approved Kael wrapper commits handoff, pushes branch, creates PR, then cleans up local worktree |
| Merge | `/kael-merge` | approved Kael merge wrapper on GitHub and sync local `main` |

## Rules

Install with `--kind rule` to layer Kael guardrails on top of existing project
RAC rules. Kael rules forbid destructive git cleanup/reset,
switching/checking out `main` or `master` during implementation runs, PR
close, and package publishing during implementation runs. Publish and merge are
handled by the dedicated `/kael-publish` and `/kael-merge` skills.

`/kael-impl` may delegate to multiple `kael-builder` agents only when approved
milestones are independent and file/surface ownership does not overlap. The
orchestrator must wait for every builder to finish before review or handoff.

For multi-boundary work, `/kael-spec` must define an architecture/module layout
and `/kael-impl` must reject implementations that collapse planned boundaries
into flat files without a plan-aligned reason.

`/kael-impl` must create or reuse a non-main implementation branch/worktree
before any builder writes. Completed builder scopes must be committed with a
conventional commit subject such as `feat(auth): add user auth guard`.

Before handoff, `/kael-impl` must append a manual test command and a specific
checklist instead of running the app. The handoff stays short and includes the
worktree path, commits, changed files, verification summary, risks, next step,
manual test command, and what to test.
If the plan includes multiple builders, `/kael-spec` should assign each builder
to a specific milestone and file/surface set so `/kael-impl` knows exactly what
to spawn.

The final response must still show the full handoff block. Writing
`.kael/handoff.md` is a copy of that handoff, not a substitute for displaying
it.

`/kael-publish` uses the installed wrapper at
`.agents/skills/kael-publish/bin/kael-publish-pr.sh` for Codex. `/kael-merge`
uses `.agents/skills/kael-merge/bin/kael-merge-pr.sh`. These are intentionally
the approved wrapper commands for projects that keep RAC starter rules denying
raw push and direct `gh pr merge`. The publish wrapper commits dirty
`.kael/handoff.md`, pushes the current feature branch, and creates the PR from
that pushed branch.

`/kael-impl` stops at a committed, PR-ready branch like Zuggie. It never opens a
PR. Use `/kael-publish` for PR creation and `/kael-merge` for merging.

## Source Of Truth

Kael is a RAC pack. RAC reads these files:

- `.rac/config.toml`
- `.rac/agents/*.toml`
- `.rac/agents/*.tpl.md`
- `.rac/rules/*.toml`
- `.rac/skills/kael-spec/SKILL.tpl.md`
- `.rac/skills/kael-impl/SKILL.tpl.md`

More detail is in [docs/kael-spec-rac-pack.md](docs/kael-spec-rac-pack.md).

## Validation

```bash
npx @raniejade/rac doctor --targets claude,codex --kind agent,skill,rule
npx @raniejade/rac install --targets claude,codex --kind agent,skill,rule --dry-run --summary
```

## Publishing A Release

Kael is installed like Zuggie: publish this repository to GitHub, tag a release,
then users install that tag with RAC.

```bash
git tag v0.1.22
git push origin main --tags
```

Create a GitHub release for `v0.1.22`, then use:

```bash
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.22
```

## License

MIT
