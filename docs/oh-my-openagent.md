# Oh My OpenAgent

Upstream repository:
<https://github.com/code-yeongyu/oh-my-openagent>

Validated reference: release `4.19.0`, commit
[`e8d842a38a7e0ed3edd5fc74f88247f8b63075ad`](https://github.com/code-yeongyu/oh-my-openagent/commit/e8d842a38a7e0ed3edd5fc74f88247f8b63075ad).
See the [2026-07-19 security audit](security-audit-2026-07-19.md) before
installing it. This pin identifies what was reviewed; it is not an endorsement
of later commits or releases.

Oh My OpenAgent, formerly Oh My OpenCode, is an opinionated agent harness for
OpenCode. It adds specialized agents, background execution, planning and review
workflows, model routing, a durable goal loop, and optional multi-agent Team
Mode.

## Why It Is Interesting

It is a practical example of graph-style agent orchestration. Instead of asking
one model to plan, research, implement, and review everything in one context,
the harness can route work through specialized roles and reconnect their
outputs:

```text
User -> planner -> orchestrator -> parallel specialists -> implementer -> reviewer
                                                                  ^          |
                                                                  |-- reject-|
```

The graph is mostly dynamic: an orchestrating model decides which specialists
to call and when. It is not a fully declarative DAG engine where every node and
dependency must be specified before execution.

## Notable Features

- Specialized planning, architecture, research, exploration, implementation,
  and review agents.
- Background agents for parallel work without filling the primary context with
  every intermediate step.
- Category-based routing so different kinds of work can use different models.
- A persistent goal loop that can continue an unfinished objective when an
  OpenCode session becomes idle.
- Team Mode with a lead, parallel members, shared tasks, mailboxes, status
  inspection, and optional per-member Git worktrees.
- Project rule and skill loading, code-intelligence tools, session recovery,
  and configurable lifecycle hooks.

## Team Mode

Team Mode is disabled by default. When enabled, it exposes `team_*` tools for
creating and managing a team, assigning and claiming work, exchanging messages,
and inspecting status.

Useful cases include:

- parallel codebase investigation
- research and implementation pipelines
- large refactors split across bounded areas
- independent plan, security, or implementation review

Team Mode is still agent-directed rather than deterministic. Shared tasks and
messages provide coordination, but the lead model remains responsible for
constructing and adapting the execution graph.

## Adoption Cautions

This is a large harness rather than a narrowly scoped skill. It can overlap
with existing OpenCode agents, goal plugins, model routing, project rules,
skills, MCP servers, and lifecycle hooks.

It is also not network-isolated. Its defaults include anonymous PostHog
telemetry, remote MCP servers, update checks, and automatic provisioning of
some tools. The audit found one downloaded comment-checker binary path without
checksum or signature verification. Use the pinned audit and a restricted
configuration if evaluating it.

Before adopting it in an established setup:

1. Try it in a separate OpenCode profile or disposable project.
2. Review the installer and generated configuration.
3. Enable Team Mode only after the ordinary orchestrator works reliably.
4. Set conservative concurrency, turn, time, and provider budgets.
5. Check which existing rules, agents, MCP servers, and goal tools it would
   replace or duplicate.
6. Validate behavior with the exact OpenCode version and model providers in
   use.

Multi-agent execution can improve separation of concerns and parallelism, but
it also increases token use, coordination overhead, and the number of agents
that can modify a worktree. More agents are useful only when the task graph has
genuinely independent or specialized nodes.

## Useful Upstream Documentation

- Repository: <https://github.com/code-yeongyu/oh-my-openagent>
- Orchestration guide:
  <https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/orchestration.md>
- Team Mode guide:
  <https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/team-mode.md>

Always consult the upstream installation guide and release notes instead of
copying version-sensitive commands into long-lived project documentation.
