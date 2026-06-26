# Sketch image for running a proxy that launches sandboxed opencode sessions.
# Pin versions for real deployments.
FROM node:22-bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bubblewrap \
    ca-certificates \
    git \
    ripgrep \
  && rm -rf /var/lib/apt/lists/*

# Install global tools once. The bubblewrap launcher exposes these read-only.
RUN npm install -g opencode-ai @playwright/test \
  && PLAYWRIGHT_BROWSERS_PATH=/ms-playwright npx playwright install chromium

RUN mkdir -p /srv/proxy /sessions /opt/agent-tools /ms-playwright \
  && chmod 755 /srv/proxy /sessions /opt/agent-tools /ms-playwright

COPY bubblewrap-opencode-serve.sh /usr/local/bin/bubblewrap-opencode-serve
RUN chmod 755 /usr/local/bin/bubblewrap-opencode-serve

WORKDIR /srv/proxy

# Replace this with the real proxy wrapper.
CMD ["node", "server.js"]
