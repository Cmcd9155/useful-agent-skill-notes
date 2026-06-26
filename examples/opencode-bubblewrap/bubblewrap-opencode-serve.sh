#!/usr/bin/env bash
set -euo pipefail

# Launch one opencode serve instance inside a bubblewrap filesystem sandbox.
#
# Expected environment:
#   SESSION_ID     unique session id, for example abc123
#   SESSION_PORT   loopback port for this opencode serve instance
#
# Expected host/container paths:
#   /sessions/$SESSION_ID/workspace
#   /sessions/$SESSION_ID/tmp
#   /sessions/$SESSION_ID/home
#   /sessions/$SESSION_ID/config/opencode/opencode.json
#   /opt/agent-tools
#   /ms-playwright

session_id="${SESSION_ID:?SESSION_ID is required}"
session_port="${SESSION_PORT:?SESSION_PORT is required}"
session_root="/sessions/${session_id}"

for path in \
  "${session_root}/workspace" \
  "${session_root}/tmp" \
  "${session_root}/home" \
  "${session_root}/config" \
  "/opt/agent-tools"; do
  if [ ! -e "$path" ]; then
    echo "missing required path: $path" >&2
    exit 1
  fi
done

exec bwrap \
  --die-with-parent \
  --new-session \
  --unshare-pid \
  --unshare-ipc \
  --unshare-uts \
  --proc /proc \
  --dev /dev \
  --tmpfs /run \
  --ro-bind /bin /bin \
  --ro-bind /usr /usr \
  --ro-bind /lib /lib \
  --ro-bind-try /lib64 /lib64 \
  --ro-bind-try /etc/hosts /etc/hosts \
  --ro-bind-try /etc/resolv.conf /etc/resolv.conf \
  --ro-bind-try /etc/nsswitch.conf /etc/nsswitch.conf \
  --ro-bind-try /etc/passwd /etc/passwd \
  --ro-bind-try /etc/group /etc/group \
  --ro-bind-try /etc/ssl /etc/ssl \
  --ro-bind-try /etc/ca-certificates /etc/ca-certificates \
  --ro-bind-try /ms-playwright /ms-playwright \
  --ro-bind /opt/agent-tools /tools \
  --ro-bind "${session_root}/config" /config \
  --bind "${session_root}/workspace" /workspace \
  --bind "${session_root}/tmp" /tmp \
  --bind "${session_root}/home" /home \
  --setenv HOME /home \
  --setenv TMPDIR /tmp \
  --setenv XDG_CACHE_HOME /home/.cache \
  --setenv XDG_CONFIG_HOME /config \
  --setenv PLAYWRIGHT_BROWSERS_PATH /ms-playwright \
  --chdir /workspace \
  /usr/local/bin/opencode serve \
    --hostname 127.0.0.1 \
    --port "${session_port}"
