# Kael Spec RAC Pack

Kael Spec is a lightweight RAC pack for plan-first AI-assisted repo work.

It borrows the useful parts of Stride and Zuggie while keeping the runtime shape
small:

- mandatory compact plan mode
- separate `/kael-spec` and `/kael-impl` commands
- explicit architecture / module layout for multi-boundary work
- protected non-main implementation branch/worktree
- conventional commit messages for completed implementation scopes
- runtime or smoke handoff from the implementation worktree
- optional PR publication from the implementation worktree with `gh` when
  explicitly requested
- PR merge workflow that merges the PR on GitHub, syncs local `main`, updates
  changelog, and pushes `main`
- copied `.env.local` or `.env` into the worktree before runtime launch when
  present on the main checkout
- explicit builder assignment maps in `/kael-spec` when multiple builders are
  useful
- compact milestones
- one or more senior implementation workers for independent, non-overlapping
  milestones
- TDD / Prove-It rules for behavior changes
- senior engineering guidance without forced over-abstraction
- proper handoff after implementation
- final implementation report
- RAC command rules layered on top of project rules
- no default reviewer, debugger, explorer, tech-lead agent, or worktree ceremony

## Install Into A Project

From the target project:

```bash
npx @raniejade/rac init --empty
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.16
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

Generated files:

- Codex skill: `.agents/skills/kael-spec/SKILL.md`
- Codex skill: `.agents/skills/kael-impl/SKILL.md`
- Codex agent: `.codex/agents/kael-builder.toml`
- Codex rules: `.codex/rules/kael-guardrails.rules`
- Claude skill and agents under `.claude/`

## Usage

```text
/kael-spec fix the broken empty state copy
/kael-impl the approved Kael Spec plan
```

## Workflow

Kael Spec always plans before code:

| Step | Owner | Output |
| --- | --- | --- |
| Plan | `/kael-spec` | compact spec and milestones |
| Approval | user | explicit approval to implement |
| Build | `/kael-impl` + `kael-builder` | code, tests, self-review; multiple builders only for non-overlapping milestones |
| Handoff | `/kael-impl` | current handoff plus appended worktree preview/smoke result and what to test next |
| Publish / cleanup | `/kael-publish` | push branch, `gh pr create`, PR URL, local worktree cleanup |
| Merge / changelog | `/kael-merge` | merge PR on GitHub, sync `main`, append changelog, commit, push `main` |
| Final report | `/kael-impl` | implementation map, interfaces, verification, risks, follow-ups |

Default command behavior:

- `/kael-spec <task>` produces a plan and stops.
- `/kael-impl <accepted plan>` invokes one `kael-builder` and ends with a
  handoff plus final implementation report.

## Rules

Kael includes RAC rules in `.rac/rules/kael-guardrails.toml`. Install with
`--kind rule` to layer them on top of existing project rules.

The rules forbid destructive git cleanup/reset, PR close, package publishing,
and switching/checking out `main` or `master` during implementation runs.
Release publishing should happen through the project's approved workflow after
the Kael handoff. Publish and merge are handled by the dedicated
`/kael-publish` and `/kael-merge` skills.

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

## Publishing A Release

Kael is installed like Zuggie: publish this repository to GitHub, tag a release,
then users install that tag with RAC.

```bash
git tag v0.1.16
git push origin main --tags
```

Create a GitHub release for `v0.1.16`, then install it in target projects:

```bash
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.16
npx @raniejade/rac install --targets codex --kind agent,skill,rule
```

## Local Pack Development

Only use a local pack reference while developing Kael itself:

```bash
cd /path/to/target-project
npx @raniejade/rac init
mkdir -p .rac
cat >> .rac/config.local.toml <<'EOF'
[[packs]]
id = "kael"
path = "/Users/kai/Documents/dev/kael"
EOF
npx @raniejade/rac install --targets claude,codex --kind agent,skill,rule --dry-run
```

Normal projects should use `rac pack add kael github:jayrmiso/kael --ref <tag>`
instead of the local `config.local.toml` entry.
