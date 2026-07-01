# Kael Spec RAC Pack

Kael Spec is a lightweight RAC pack for plan-first AI-assisted repo work.

It borrows the useful parts of Stride and Zuggie while keeping the runtime shape
small:

- mandatory compact plan mode
- compact milestones
- one senior implementation worker
- TDD / Prove-It rules for behavior changes
- senior engineering guidance without forced over-abstraction
- proper handoff after implementation
- final implementation report
- RAC command rules layered on top of project rules
- no default reviewer, debugger, explorer, tech-lead agent, or worktree ceremony

## Install Into A Project

From the target project:

```bash
npx @raniejade/rac init
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.1
npx @raniejade/rac install --targets claude,codex --kind agent,skill,rule
```

Use the latest published Kael release tag in `--ref`. Avoid installing from
`main` for normal projects; release tags keep installs reproducible.

For Codex only:

```bash
npx @raniejade/rac install --targets codex --kind agent,skill,rule
```

Generated files:

- Codex skill: `.agents/skills/kael-spec/SKILL.md`
- Codex agent: `.codex/agents/kael-builder.toml`
- Codex rules: `.codex/rules/kael-guardrails.rules`
- Claude skill and agents under `.claude/`

## Usage

```text
/kael-spec fix the broken empty state copy
/kael-spec plan add usage limits to the billing API
/kael-spec implement the accepted milestone plan
```

## Workflow

Kael Spec always plans before code:

| Step | Owner | Output |
| --- | --- | --- |
| Plan | `/kael-spec` orchestrator | compact spec and milestones |
| Approval | user | explicit approval to implement |
| Build | `kael-builder` | code, tests, self-review |
| Handoff | `/kael-spec` orchestrator | status, changed files, tests, manual checks, next step |
| Final report | `/kael-spec` orchestrator | implementation map, interfaces, verification, risks, follow-ups |

Default command behavior:

- `/kael-spec <task>` produces a plan and stops.
- `/kael-spec plan <task>` produces a plan and stops.
- `/kael-spec implement <accepted plan>` invokes one `kael-builder` and ends
  with a handoff plus final implementation report.

## Rules

Kael includes RAC rules in `.rac/rules/kael-guardrails.toml`. Install with
`--kind rule` to layer them on top of existing project rules.

The rules forbid direct push, merge, destructive git cleanup/reset, PR
mutation/merge, and package publishing during implementation runs. Publishing
and PR lifecycle work should happen through the project's approved workflow
after the Kael handoff.

## Publishing A Release

Kael is installed like Zuggie: publish this repository to GitHub, tag a release,
then users install that tag with RAC.

```bash
git tag v0.1.1
git push origin main --tags
```

Create a GitHub release for `v0.1.1`, then install it in target projects:

```bash
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.1
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
