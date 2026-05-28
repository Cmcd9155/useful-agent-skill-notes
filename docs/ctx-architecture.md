# ctx Architecture Skill

`ctx-architecture` is a workflow for building and maintaining architecture
maps from the codebase. I use it when a repo needs durable architecture context
that future agent sessions can load quickly.

## Upstream Links

- `ctx` repo: <https://github.com/ActiveMemory/ctx>
- `ctx` docs: <https://ctx.ist>
- `ctx` license: <https://github.com/ActiveMemory/ctx/blob/main/LICENSE>
- skill source:
  <https://github.com/ActiveMemory/ctx/tree/main/internal/assets/claude/skills/ctx-architecture>

## License Note

`ctx` is licensed under Apache-2.0, not MIT. That still makes it broadly usable
as open source software: people can generally use it, modify it, redistribute
it, and use it commercially, provided they follow the Apache-2.0 requirements.

This repo links to the upstream skill instead of copying it. If you vendor or
modify upstream skill files, preserve the upstream license notices and check the
license text directly.

## What It Does

The skill keeps architecture documentation in `.context/`:

- `.context/ARCHITECTURE.md` for the high-level system map
- `.context/DETAILED_DESIGN.md` or split detailed-design files for module notes
- `.context/CHEAT-SHEETS.md` for quick operational references
- `.context/DANGER-ZONES.md` for risky areas
- `.context/CONVERGENCE-REPORT.md` for coverage and confidence
- `.context/map-tracking.json` for what has been analyzed and how stale it is

The useful idea is incremental mapping. The agent does not need to rediscover
the whole repo every time. It can check tracking metadata, inspect changed
areas, and refresh only the architecture surfaces that actually moved.

## How It Finds Stale Architecture Docs

The workflow uses several simple signals:

- Broken path references: if architecture docs mention a file or folder that no
  longer exists, `ctx drift` can flag it.
- Missing required files: if expected `.context` files are gone, `ctx doctor`
  or `ctx drift` can notice.
- Staleness markers: old context, too many completed tasks, or docs that have
  not been refreshed recently can suggest cleanup or a new pass.
- Git changes: the skill can compare module analysis dates against `git log`.
- Coverage tracking: `.context/map-tracking.json` records analyzed modules,
  timestamps, confidence, and notes.
- Repo scan: `ctx sync` can find new directories or manifest changes that docs
  may not mention yet.

The update loop is:

```text
Repo changes
  -> ctx drift/sync/status reveals possible stale context
  -> ctx-architecture reads the changed or low-confidence areas
  -> ARCHITECTURE.md, DETAILED_DESIGN.md, and map-tracking.json are refreshed
```

This is not automatic perfection. It is a lightweight maintenance system that
makes drift visible and gives agents enough structure to update the docs from
the actual code.

## Install

Follow the upstream `ctx` installation instructions:

```bash
git clone https://github.com/ActiveMemory/ctx.git
cd ctx
make build
sudo make install
```

For skill installation, use the upstream instructions for your agent. The
source lives in the `ActiveMemory/ctx` repo, and marketplace/installer support
may vary by agent.

## Per-Repo Setup

Initialize `ctx` in the target repo:

```bash
ctx init
ctx status
```

For an existing project that already has docs you do not want overwritten, use
the upstream `ctx init` options carefully, such as minimal or merge modes when
appropriate.

Then add a short rule to `AGENTS.md` or your agent's equivalent project
instructions:

```md
## Architecture Documentation

- Use the `ctx-architecture` skill to create or refresh architecture docs.
- After meaningful module-boundary, service-contract, data-flow, storage,
  runtime, or lifecycle changes, update the `.context/` architecture map.
- Do not refresh architecture docs for tiny internal edits that do not change
  boundaries, dependencies, or behavior.
```

## When I Use It

Use it for:

- first architecture map for a repo
- a significant refactor
- new service/module boundaries
- new persistence or storage flows
- changed lifecycle/startup/shutdown behavior
- new external-provider or integration boundary
- stale architecture maps after meaningful code changes

Skip it for:

- tiny bug fixes
- copy changes
- local implementation edits that do not affect system shape
- one-line docs updates

## How I Ask The Agent

Useful prompts:

```text
Use ctx-architecture to refresh the architecture map for this repo.
```

```text
Use ctx-architecture on the auth and billing modules only.
```

```text
This change affects service startup and storage paths. Update the ctx
architecture docs after the code change.
```

## Operating Principle

The code is the source of truth. The architecture docs are a map. If the agent
is unsure, it should read the code and mark confidence honestly instead of
pretending the map is complete.
