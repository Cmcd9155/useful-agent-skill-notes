# opencode bubblewrap Sandbox

This note sketches a practical way to run many `opencode serve` processes inside
one Docker container while keeping each session limited to its own writable
folder and a small set of read-only runtime dependencies.

The important idea is:

```text
Docker container = outer deployment unit
proxy wrapper = only session launcher
bubblewrap = per-process filesystem view
opencode.json = app-level agent policy
```

`opencode.json` is useful policy, but it should not be the only boundary. The
proxy should launch each `opencode serve` through `bwrap` so the process only
sees paths that were explicitly mounted into its sandbox.

## Target Shape

```text
container
  /srv/proxy
  /opt/agent-tools/read-only-approved-tools
  /usr/local/bin/opencode
  /usr/local/bin/playwright
  /usr/local/lib/node_modules
  /ms-playwright
  /sessions
    /abc
      /workspace
      /tmp
      /home
      /config/opencode/opencode.json
```

Each session gets its own directory under `/sessions`. The proxy writes the
approved tool config and then starts `opencode serve` with a sandbox view like:

```text
/
  workspace/   read-write session workspace
  tmp/         read-write session temp
  home/        read-write session home/cache
  config/      read-only generated OpenCode config root
  tools/       read-only approved tools
  usr/         read-only runtime binaries and global node packages
  bin/         read-only shell/runtime binaries
  lib/         read-only runtime libraries
  lib64/       read-only runtime libraries, when present
  ms-playwright/ read-only browser binaries, when used
```

Anything not bound into the bubblewrap command is invisible to that process.

## Session Launch Flow

```text
POST /sessions
-> proxy validates user/auth
-> proxy chooses an internal port
-> proxy creates /sessions/<id>/{workspace,tmp,home,config}
-> proxy writes /sessions/<id>/config/opencode/opencode.json
-> proxy starts examples/bubblewrap-opencode-serve.sh
-> proxy routes the user to 127.0.0.1:<port>
-> idle timeout deletes the process and session folder
```

The public interface should never allow users to pass raw `bwrap` flags or raw
`opencode serve` arguments. Users request a session; the proxy owns the launch
contract.

## What Must Be Read-Only

Global dependencies can be readable without being writable:

- `opencode` global package
- Node or Bun runtime
- approved CLI tools such as `playwright`
- Playwright browser binaries
- system libraries required to execute those tools
- approved shared tool definitions

The usual first version binds `/usr`, `/bin`, `/lib`, and `/lib64` read-only
because Node and Playwright often need more support files than expected. Later,
you can narrow the bind list if the image is stable and you want a stricter
runtime view.

## What Should Be Writable

Only session-owned directories should be writable:

- `/workspace`
- `/tmp`
- `/home`

Set the environment so common tools write into those paths:

```text
HOME=/home
TMPDIR=/tmp
XDG_CACHE_HOME=/home/.cache
XDG_CONFIG_HOME=/config
PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
```

## Example Files

- [bubblewrap launcher](../examples/opencode-bubblewrap/bubblewrap-opencode-serve.sh)
- [Dockerfile sketch](../examples/opencode-bubblewrap/Dockerfile)
- [sample generated config](../examples/opencode-bubblewrap/sample-session/config/opencode/opencode.json)

These examples are intentionally small. Treat them as a starting contract for a
proxy wrapper, not as a complete hosted product.

## Practical Caveats

- bubblewrap needs Linux user namespaces or enough container permissions to
  create its sandbox.
- Running bubblewrap inside Docker may require host/container runtime tuning.
- This is process isolation, not a full VM boundary.
- Do not mount the Docker socket, cloud credentials, SSH keys, or the proxy's
  private config into the sandbox.
- Use per-session ports and keep them bound to loopback inside the container.
- Add CPU, memory, pid, disk, idle, and max-lifetime limits outside this
  launcher.

## When To Use Something Stronger

This pattern is reasonable when tools are admin-approved and the goal is to
prevent accidental or opportunistic filesystem access between sessions.

Consider per-session containers, gVisor, Kata Containers, or Firecracker-style
microVMs when users can run arbitrary code, install arbitrary packages, bring
unknown tools, or handle high-value tenant data.
