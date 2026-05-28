# Useful Agent Skill Notes

Public notes for agent skills and project-context workflows I find useful.

This repo does not vendor or republish any third-party skill files. It is a
small, generic field guide for installing upstream skills and integrating them
into a repo through ordinary project docs such as `AGENTS.md`, `.context/`,
`CONTEXT.md`, and `docs/adr/`.

## What Is Here

| Note | What it covers |
|---|---|
| [ctx architecture](docs/ctx-architecture.md) | How I use `ctx` plus the `/ctx-architecture` skill to keep architecture docs fresh. |
| [grill-with-docs](docs/grill-with-docs.md) | How I use `/grill-with-docs` to stress-test plans against project language and ADRs. |
| [repo setup checklist](docs/repo-setup-checklist.md) | A generic checklist for wiring these workflows into a project. |

## Sources

- `ctx`: <https://github.com/ActiveMemory/ctx>
- `ctx` docs: <https://ctx.ist>
- `ctx` license: Apache-2.0, not MIT. See
  <https://github.com/ActiveMemory/ctx/blob/main/LICENSE>.
- `ctx-architecture` skill source:
  <https://github.com/ActiveMemory/ctx/tree/main/internal/assets/claude/skills/ctx-architecture>
- Matt Pocock skills repo: <https://github.com/mattpocock/skills>
- `grill-with-docs` skill source:
  <https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs>

## License Context

This notes repo is MIT licensed because it only contains my generic setup notes.

The upstream `ctx` project is Apache-2.0 licensed. Apache-2.0 is still a
permissive open source license: people can generally use, modify, redistribute,
and build on the project, including commercially, as long as they follow the
license terms such as preserving notices and marking modified files. Apache-2.0
also includes an explicit patent grant.

Always check each upstream repository's own license before copying source files
or vendoring a skill.

## Safety Boundary

These notes are intentionally generic:

- no private application details
- no secrets
- no API keys
- no production URLs
- no copied private prompts
- no generated content from private projects

Use the linked upstream repositories for the actual skill implementations.

## Basic Pattern

The pattern I like is:

1. Install the skill from the upstream source.
2. Add a short `AGENTS.md` or equivalent project-instructions file telling the
   agent when to use it.
3. Keep durable project knowledge in versioned docs.
4. Make the agent update those docs only when the project shape or language
   actually changes.

In practice, that gives the agent useful memory without turning every chat into
a giant prompt.

## How ctx Helps Keep Docs Fresh

`ctx` does not magically guarantee that docs are always current. It gives the
agent useful signals that docs may be stale, then the agent or human refreshes
the relevant files.

Signals `ctx` and the architecture workflow can use:

- Broken path references: if `ARCHITECTURE.md` mentions a file or folder that
  no longer exists, `ctx drift` can flag it.
- Missing required files: if expected `.context` files are gone, `ctx doctor`
  or `ctx drift` can notice.
- Staleness markers: too many completed tasks, old context, or docs that have
  not been refreshed recently can suggest cleanup or a refresh.
- Git changes: the architecture skill can compare analyzed module dates against
  `git log`.
- Coverage tracking: `.context/map-tracking.json` records which modules were
  analyzed, when they were analyzed, and with what confidence.
- Repo scan: `ctx sync` can scan for new directories or manifest changes that
  docs may not mention yet.

The practical loop is:

```text
Code changes -> ctx detects drift or AGENTS.md rules trigger a refresh
             -> agent runs ctx-architecture
             -> .context docs and map-tracking.json are updated
```

So I think of it as a smoke alarm plus a maintenance routine: `ctx` points at
likely drift, and the architecture skill updates the map from the code.
