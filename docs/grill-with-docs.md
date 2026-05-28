# grill-with-docs

`grill-with-docs` is a planning and design skill. I use it before implementation
when a plan needs sharper language, clearer boundaries, or a check against
existing decisions.

## Upstream Links

- Matt Pocock skills repo: <https://github.com/mattpocock/skills>
- skill source:
  <https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs>
- skill listing: <https://www.skills.sh/mattpocock/skills/grill-with-docs>

## What It Does

The skill challenges a plan against the repo's existing domain language and
decision history.

It looks for docs like:

- `CONTEXT.md` for project/domain vocabulary
- `CONTEXT-MAP.md` for multi-context repos
- `docs/adr/` for Architecture Decision Records

During a session, the agent asks focused questions, checks the code when an
answer can be discovered locally, sharpens fuzzy terms, and updates docs when a
term or decision becomes stable.

## Install

Use the upstream installer instructions. A common install path is:

```bash
npx skills@latest add mattpocock/skills
```

You can also install only the relevant skill if your installer supports that:

```bash
npx skills add mattpocock/skills --skill grill-with-docs
```

Check the upstream repo for current installation details.

## Per-Repo Setup

Add or allow the skill to create these files lazily:

```text
CONTEXT.md
docs/adr/
```

For a larger repo with multiple bounded contexts, use:

```text
CONTEXT-MAP.md
docs/adr/
src/example-context/CONTEXT.md
src/example-context/docs/adr/
```

Then add a short rule to `AGENTS.md` or your equivalent project instructions:

```md
## Planning With Project Language

- Use `grill-with-docs` when stress-testing a plan, feature shape, domain
  terminology, or architecture decision.
- Keep `CONTEXT.md` focused on domain language, not implementation details.
- Create ADRs only for decisions that are hard to reverse, surprising without
  context, and the result of a real trade-off.
- If the code contradicts the plan or glossary, surface the contradiction
  before proceeding.
```

## When I Use It

Use it before:

- feature design
- domain model changes
- API or service boundary changes
- data model changes
- naming a new concept
- making an architectural trade-off

Skip it for:

- mechanical refactors
- tiny bug fixes
- obvious local changes
- decisions that are easy to reverse and not worth recording

## How I Ask The Agent

Useful prompts:

```text
Use grill-with-docs to stress-test this plan before implementation.
```

```text
Grill me on this design and update CONTEXT.md if we settle new terms.
```

```text
Challenge this against existing ADRs before we code it.
```

## Operating Principle

`CONTEXT.md` is the shared language. ADRs are the memory of hard decisions.
The skill is valuable because it turns planning conversation into durable
project context instead of leaving the useful parts trapped in chat history.
