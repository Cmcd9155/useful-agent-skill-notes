# Security Audit: Reference Repositories

Audit date: 2026-07-19

This is a source-level review of the exact revisions below. It is not a formal
penetration test, a malware-free guarantee, or a review of later revisions,
transitive package contents, hosted services, or model providers.

## Pinned Revisions

| Repository | Audited revision | Result |
|---|---|---|
| `Cmcd9155/useful-agent-skill-notes` | [`f0e4886f5d5a7155871cfdf58530ef9105d35dd9`](https://github.com/Cmcd9155/useful-agent-skill-notes/commit/f0e4886f5d5a7155871cfdf58530ef9105d35dd9) plus the Markdown-only reference additions staged with this audit | Low risk; inert documentation |
| `code-yeongyu/oh-my-openagent` | release `4.19.0`, [`e8d842a38a7e0ed3edd5fc74f88247f8b63075ad`](https://github.com/code-yeongyu/oh-my-openagent/commit/e8d842a38a7e0ed3edd5fc74f88247f8b63075ad) | Does not satisfy a no-network or OpenCode-config-only policy |

## Useful Agent Skill Notes

The pinned upstream tree contains Markdown, a license, and `.gitignore`. It has
no package manifest, executable source, install lifecycle, hooks, binaries, or
runtime dependencies. Searches for common network and process-execution paths
found only ordinary links and a documented `git clone` example.

The local additions covered by this audit are also Markdown-only. On that
basis, this repository is inert unless a reader manually runs a command from
its documentation.

## Oh My OpenAgent

Oh My OpenAgent is an executable agent harness with broad intended
capabilities. It does substantially more than update OpenCode configuration.
No clear credential-stealing or covert prompt/source upload path was found in
the reviewed code, but the following network and local-system actions are
intentional.

### Network and Privacy Findings

- Anonymous PostHog telemetry is enabled when `telemetry` is omitted. It sends
  a daily activity event to `https://us.i.posthog.com` with a stable identifier
  derived from the hostname and environment metadata such as product/version,
  runtime, OS, architecture, CPU, memory, locale, timezone, shell, terminal,
  and CI status. The reviewed event did not include prompts, transcripts, or
  source code. PostHog may still infer geography from the connection IP.
- Built-in remote MCPs are enabled by default for Exa (or configured Tavily),
  Context7, and grep.app. Search queries and tool parameters leave the machine
  when those tools are invoked.
- It supports arbitrary configured HTTP MCP OAuth connections, web fetching,
  and user-configured HTTPS hooks. HTTPS hooks reject non-loopback plain HTTP
  and redirects and restrict environment-variable header interpolation, which
  are useful safeguards, but hook input can still be deliberately sent out.
- The automatic update checker is enabled by default. It queries package
  metadata and can invalidate the cached package and run `bun install` for an
  unpinned installation. A pinned plugin entry skips automatic replacement.
- CodeGraph is enabled with automatic initialization and provisioning by
  default. Its provisioned archive is SHA-256 checked, and its runtime is
  launched with CodeGraph telemetry and further downloads disabled.
- The comment-checker hook can download a release binary from
  `code-yeongyu/go-claude-code-comment-checker`, extract it, and execute it.
  The reviewed downloader validates archive paths but does not verify a
  checksum or signature. This is the most notable supply-chain weakness found.

### Local-System Findings

- The package `postinstall` script executes `opencode --version`, removes
  matching cached plugin directories, and verifies a platform binary package.
- The CLI launches a platform-specific executable with the current process
  environment.
- Install and runtime code writes OpenCode and plugin configuration, makes
  configuration backups, writes state under the user profile, and can manage
  task state, Git worktrees, background agents, LSP processes, and tmux
  sessions. These capabilities are expected for the harness but exceed a
  configuration-only trust boundary.

## Verdict

The notes repository is suitable as a passive reference at the pinned commit.

Oh My OpenAgent was not found to be obviously malicious, but it fails the
requested standard of making no data calls and only updating OpenCode. Its
default posture creates privacy, supply-chain, and operational risk. Treat it
as a privileged development tool and do not install it with defaults on a
sensitive machine or repository.

For an evaluation, pin `oh-my-openagent@4.19.0` and start with a restrictive
plugin configuration:

```json
{
  "telemetry": false,
  "auto_update": false,
  "disabled_mcps": ["websearch", "context7", "grep_app", "codegraph"],
  "disabled_hooks": ["comment-checker"],
  "codegraph": {
    "enabled": false,
    "auto_init": false,
    "auto_provision": false
  }
}
```

This reduces the plugin-added automatic network paths found in this audit. It
does not make OpenCode, model providers, user-enabled hooks, browser tools, or
other installed plugins offline. Re-audit before changing the pin.
