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
- `ctx-architecture` skill source:
  <https://github.com/ActiveMemory/ctx/tree/main/internal/assets/claude/skills/ctx-architecture>
- Matt Pocock skills repo: <https://github.com/mattpocock/skills>
- `grill-with-docs` skill source:
  <https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs>

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
