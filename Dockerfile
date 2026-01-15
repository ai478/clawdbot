FROM node:22-bookworm

# Install Bun (required for build scripts)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# Install Docker CLI (required for sandbox mode)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    jq && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install browser dependencies (for agent-browser / puppeteer)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Install glab (GitLab CLI)
RUN curl -fsSL https://gitlab.com/gitlab-org/cli/-/releases/v1.80.4/downloads/glab_1.80.4_linux_amd64.deb -o /tmp/glab.deb \
    && dpkg -i /tmp/glab.deb \
    && rm /tmp/glab.deb

RUN corepack enable

# Configure pnpm and Go for global installs (required for skills)
ENV SHELL=/bin/bash
ENV PNPM_HOME="/home/node/.local/share/pnpm"
ENV GOPATH="/home/node/go"
ENV PATH="$PNPM_HOME:$GOPATH/bin:$PATH"

# Map 'node' user to UID 1001 to match host user 'clawdis'
# Also handle Docker group permissions if DOCKER_GID is provided
ARG DOCKER_GID=""
RUN usermod -u 1001 node && \
    groupmod -g 1001 node && \
    if [ -n "$DOCKER_GID" ]; then \
      if getent group "$DOCKER_GID"; then \
        usermod -aG $(getent group "$DOCKER_GID" | cut -d: -f1) node; \
      else \
        groupadd -g "$DOCKER_GID" docker_host && \
        usermod -aG docker_host node; \
      fi; \
    fi && \
    rm -rf /home/node/.local /home/node/go /home/node/.cache && \
    mkdir -p /home/node/.local/share/pnpm/store /home/node/go /home/node/.cache /app && \
    chown -R node:node /home/node /app

USER node

# Configure pnpm and Go for global installs (required for skills)
ENV SHELL=/bin/bash
ENV PNPM_HOME="/home/node/.local/share/pnpm"
ENV GOPATH="/home/node/go"
ENV PATH="$PNPM_HOME:$GOPATH/bin:$PATH"

# Ensure pnpm uses the local store and home for everything
RUN pnpm config set store-dir /home/node/.local/share/pnpm/store && \
    pnpm config set prefix /home/node/.local

# Install Claude Code CLI
RUN pnpm add -g @anthropic-ai/claude-code

# Install OpenAI Codex CLI
RUN npm install -g @openai/codex

WORKDIR /app

ARG CLAWDBOT_DOCKER_APT_PACKAGES=""
RUN if [ -n "$CLAWDBOT_DOCKER_APT_PACKAGES" ]; then \
      apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $CLAWDBOT_DOCKER_APT_PACKAGES && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*; \
    fi

COPY --chown=node:node package.json pnpm-lock.yaml pnpm-workspace.yaml .npmrc ./
COPY --chown=node:node ui/package.json ./ui/package.json
COPY --chown=node:node patches ./patches
COPY --chown=node:node scripts ./scripts

ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN pnpm install --frozen-lockfile

COPY --chown=node:node . .
RUN pnpm build
RUN pnpm ui:install
RUN pnpm ui:build

# Create agent-browser alias
USER root
RUN echo '#!/bin/bash\nnode /app/dist/entry.js browser "$@"' > /usr/local/bin/agent-browser \
    && chmod +x /usr/local/bin/agent-browser
USER node

ENV NODE_ENV=production

CMD ["node", "dist/index.js"]
