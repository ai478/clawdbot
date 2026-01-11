# Clawdbot Server Setup Guide (Docker + NPM Sandbox)

**Note for Non-Root Users:** This guide assumes you have access to `docker` and `git` commands. Since you cannot use `sudo`, we will skip package installation and assume the environment is already provisioned.

## 1. Verify Prerequisites

Run these commands to check if you have the necessary tools and permissions:

```bash
# Check if you can run Docker containers (should print "Hello from Docker!")
docker run --rm hello-world

# Check if Git is installed
git --version

# Check if Docker Compose is available
docker compose version
```

_If `docker run` fails with "permission denied", you need to ask your administrator to add your user (`clawdis`) to the `docker` group._

## 2. Download Clawdbot

Clone the repository:

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot
```

## 3. Build the Gateway

Build the main Clawdbot image and run the onboarding wizard.

**Important:** Before running `docker compose`, create a `.env` file to set the volume paths correctly:

```bash
cat > .env <<EOF
CLAWDBOT_CONFIG_DIR=$HOME/.clawdbot
CLAWDBOT_WORKSPACE_DIR=$HOME/clawd
CLAWDBOT_GATEWAY_PORT=18789
CLAWDBOT_BRIDGE_PORT=18790
CLAWDBOT_GATEWAY_BIND=lan
EOF
```

Then build and onboard. The `onboard` command might fail if permissions are bad, but we fix that later.

```bash
# Build the local image
docker build -t clawdbot:local -f Dockerfile .

# Clean slate: Remove any existing config to avoid permission conflicts
docker run --rm -v ~/.clawdbot:/config alpine rm -f /config/clawdbot.json

# Run onboarding with defaults (non-interactive)
docker compose run --rm clawdbot-cli onboard --flow quickstart --auth-choice skip --skip-providers --skip-skills --skip-daemon --skip-ui
```

## 4. Build the Sandbox Images

You need to build the base sandbox image first, then the "common" image which adds `npm`, `node`, `python`, etc.

```bash
# Make scripts executable
chmod +x scripts/sandbox-setup.sh scripts/sandbox-common-setup.sh

# 1. Build base sandbox (clawdbot-sandbox:bookworm-slim)
./scripts/sandbox-setup.sh

# 2. Build common sandbox with tools (clawdbot-sandbox-common:bookworm-slim)
./scripts/sandbox-common-setup.sh
```

## 5. Configure Clawdbot (Permission Fix)

Because Docker created the `~/.clawdbot` directory, your user (`clawdis`) might not have permission to edit `clawdbot.json`.

**Step 5a: Fix Permissions (Using Docker)**

This command uses a temporary Docker container to change the ownership of the `~/.clawdbot` directory to your current user ID.

```bash
# Replace 1000:1000 if your UID is different (check with 'id -u')
docker run --rm -v ~/.clawdbot:/config alpine chown -R 1001:1001 /config
```

**Step 5b: Write Configuration**

Now that you own the directory, you can write the config file directly:

```bash
cat <<EOF > ~/.clawdbot/clawdbot.json
{
  "agent": {
    "model": "anthropic/claude-3-5-sonnet-20241022",
    "thinking": {
      "budget": 4096
    }
  },
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "non-main",
        "docker": {
          "image": "clawdbot-sandbox-common:bookworm-slim"
        }
      }
    }
  },
  "models": {
    "anthropic": {
      "apiKey": "sk-ant-oat01XXXXXXXXXXXXXXXXXXXXXAAA"
    }
  }
}
EOF
```

## 6. Start the Gateway

Launch the gateway in the background.

```bash
docker compose up -d clawdbot-gateway
```

## 7. Verify

Check if `npm` is available by asking the bot to run a command in the sandbox. You can do this via the CLI container:

```bash
docker compose exec clawdbot-gateway node dist/index.js agent --message "Check if npm is installed by running 'npm --version'" --thinking low
```

If successful, the bot should report the npm version installed in the sandbox.
