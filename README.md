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
- runtime or smoke handoff from the implementation worktree
- optional PR publication from the implementation worktree with `gh` when
  explicitly requested
- PR merge workflow with changelog update and direct push to `main` using `gh`
- copied `.env.local` or `.env` into the worktree before runtime launch when
  present on the main checkout
- explicit builder assignment maps in `/kael-spec` when multiple builders are
  useful
- compact milestones
- one or more senior builder workers for independent, non-overlapping code
  milestones
- TDD / Prove-It rules for behavior changes
- senior engineering guidance without forced over-abstraction
- concrete handoff after implementation
- final implementation report
- RAC command rules layered on top of project rules

## Install

From the project where you want to use Kael:

```bash
npx @raniejade/rac init --empty
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.14
npx @raniejade/rac install --targets claude,codex --kind agent,skill,rule
```

Use the latest published Kael release tag in `--ref`. Avoid installing from
`main` for normal projects; release tags keep installs reproducible.

Use `rac init --empty` for a Kael-only setup. The default `rac init` starter
pack adds project wrapper rules that deny raw `git push`; keep those only when
your project also provides the approved push/PR wrapper commands.

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
| Handoff | `/kael-impl` | current handoff plus appended worktree preview/smoke result and what to test next |
| Publish / cleanup | `/kael-publish` | push branch, `gh pr create`, PR URL, local worktree cleanup |
| Merge / changelog | `/kael-merge` | merge PR to `main`, append changelog, commit, push `main` |
| Final report | `/kael-impl` | implementation map, interfaces, verification, risks, follow-ups |

## Rules

Install with `--kind rule` to layer Kael guardrails on top of existing project
RAC rules. Kael rules forbid destructive git cleanup/reset,
switching/checking out `main` or `master` during implementation runs, PR
close, and package publishing during implementation runs. Publish and merge are
handled by the dedicated `/kael-publish` and `/kael-merge` skills.

`/kael-impl` may delegate to multiple `kael-builder` agents only when approved
milestones are independent and file/surface ownership does not overlap. The
orchestrator must wait for every builder to finish before review, handoff, or
final report.

For multi-boundary work, `/kael-spec` must define an architecture/module layout
and `/kael-impl` must reject implementations that collapse planned boundaries
into flat files without a plan-aligned reason.

`/kael-impl` must create or reuse a non-main implementation branch/worktree
before any builder writes. Completed builder scopes must be committed with a
conventional commit subject such as `feat(auth): add user auth guard`.

Before handoff, `/kael-impl` must start or smoke-test the changed app, service,
API, UI, or CLI from the implementation worktree when a runnable surface exists.
The existing handoff fields stay intact; Kael appends the worktree path, start
command, URL or smoke target, verification command, runtime status, and a
specific checklist of what you should test.
If the main checkout has `.env.local` or `.env`, Kael copies the best available
file into the created worktree before launch and reports that source/target path
in the handoff.
If the plan includes multiple builders, `/kael-spec` should assign each builder
to a specific milestone and file/surface set so `/kael-impl` knows exactly what
to spawn.

The final response must still show the full handoff block. Writing
`.kael/handoff.md` is a copy of that handoff, not a substitute for displaying
it.

By default, `/kael-impl` stops at a committed, PR-ready branch like Zuggie. If
you explicitly ask it to open a PR, it may hand off to `/kael-publish` to push
the implementation branch from the worktree and create a PR. It must not
approve the PR, merge it, or update local main.

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
git tag v0.1.14
git push origin main --tags
```

Create a GitHub release for `v0.1.14`, then use:

```bash
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.14
```

## License

MIT
