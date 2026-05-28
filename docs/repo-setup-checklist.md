# Repo Setup Checklist

This is the generic setup pattern I use when adding durable agent-context
workflows to a repo.

## 1. Add Project Instructions

Create or update `AGENTS.md` with short rules for when skills should run.

Example:

```md
# Agent Notes

## Progress Tracking

- For multi-step implementation work, track progress and update it as work
  completes.

## Architecture Documentation

- Use `ctx-architecture` to create or refresh `.context/` architecture docs.
- Refresh architecture docs after meaningful boundary, contract, data-flow,
  storage, runtime, or lifecycle changes.

## Planning With Project Language

- Use `grill-with-docs` when stress-testing plans against project vocabulary or
  existing ADRs.
- Keep `CONTEXT.md` as a glossary of domain terms.
- Add ADRs only for hard-to-reverse, surprising, trade-off-heavy decisions.
```

## 2. Initialize ctx

```bash
ctx init
ctx status
```

For an existing repo, review upstream `ctx init` options before allowing any
template writes.

## 3. Create Durable Docs

Architecture docs:

```text
.context/ARCHITECTURE.md
.context/DETAILED_DESIGN.md
.context/CHEAT-SHEETS.md
.context/DANGER-ZONES.md
.context/CONVERGENCE-REPORT.md
.context/map-tracking.json
```

Domain and decision docs:

```text
CONTEXT.md
docs/adr/
```

These files should be versioned unless your project has a specific reason not
to commit them.

## 4. Keep Skill Content Upstream

Do not copy third-party `SKILL.md` bodies into random repos unless the license
and your maintenance plan make that a deliberate choice.

Prefer:

- link to the upstream repo
- document how you use the skill
- pin a version only when reproducibility matters
- periodically check upstream for changes

## 5. Avoid Leaks

Before publishing setup notes, check for:

- secrets and tokens
- private hostnames
- internal project names
- customer/user data
- production credentials
- private prompts or proprietary instructions
- generated examples that reveal private workflows

## 6. Suggested First Run

```text
Use ctx-architecture to create a first architecture map for this repo.
```

Then:

```text
Use grill-with-docs to stress-test the next feature plan against the project
language and any ADRs.
```

That gives the agent both a system map and a vocabulary map before it starts
making larger changes.
