#!/bin/bash
# Codex CLI Proxy - Secure wrapper that uses auth.json instead of env vars
# This prevents the agent from seeing the API key while still allowing tool usage

# Set auth file location (read-only mounted from host)
export CODEX_AUTH_FILE="/home/node/.codex/auth.json"

# Check if auth file exists
if [ ! -f "$CODEX_AUTH_FILE" ]; then
  echo "Error: Codex auth file not found at $CODEX_AUTH_FILE"
  exit 1
fi

# Execute codex-cli with all passed arguments
# Agent can use: /shared/scripts/codex-proxy.sh create "description"
exec codex-cli "$@"
