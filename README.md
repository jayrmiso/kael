# Kael Spec

Kael Spec is a lightweight RAC pack for plan-first AI-assisted repo work.

It keeps the useful parts of Stride and Zuggie while staying intentionally
small:

- `/kael-spec` as the single workflow entrypoint
- mandatory compact plan mode before implementation
- compact milestones
- one senior builder worker for code changes
- TDD / Prove-It rules for behavior changes
- senior engineering guidance without forced over-abstraction
- concrete handoff after implementation
- final implementation report
- RAC command rules layered on top of project rules

## Install

From the project where you want to use Kael:

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

## Usage

```text
/kael-spec fix the broken empty state copy
/kael-spec plan add usage limits to the billing API
/kael-spec implement the accepted milestone plan
```

## What Gets Installed

- Codex skill: `.agents/skills/kael-spec/SKILL.md`
- Codex agents:
  - `.codex/agents/kael-builder.toml`
- Codex rules:
  - `.codex/rules/kael-guardrails.rules`
- Claude skill and agents under `.claude/`

## Workflow

Kael always plans before code:

| Step | Owner | Output |
| --- | --- | --- |
| Plan | `/kael-spec` orchestrator | compact spec and milestones |
| Approval | user | explicit approval to implement |
| Build | `kael-builder` | code, tests, self-review |
| Handoff | `/kael-spec` orchestrator | status, changed files, tests, manual checks, next step |
| Final report | `/kael-spec` orchestrator | implementation map, interfaces, verification, risks, follow-ups |

## Rules

Install with `--kind rule` to layer Kael guardrails on top of existing project
RAC rules. Kael rules forbid direct push, merge, destructive git cleanup/reset,
PR mutation/merge, and package publishing during implementation runs.

## Source Of Truth

Kael is a RAC pack. RAC reads these files:

- `.rac/config.toml`
- `.rac/agents/*.toml`
- `.rac/agents/*.tpl.md`
- `.rac/rules/*.toml`
- `.rac/skills/kael-spec/SKILL.tpl.md`

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
git tag v0.1.1
git push origin main --tags
```

Create a GitHub release for `v0.1.1`, then use:

```bash
npx @raniejade/rac pack add kael github:jayrmiso/kael --ref v0.1.1
```

## License

MIT
