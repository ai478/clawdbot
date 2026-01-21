WARN[0000] The "CLAUDE_AI_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_WEB_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_WEB_COOKIE" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "TELEGRAM_BOT_TOKEN" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] No services to build                         
i deleted the telegram token and api key for the brave api in the clawdbot.json in the server and i git pull and did this 
docker compose up -d
but 
i added them in the onboard command the brave api key and telegram token 
clawdis@Cyrus-Wondura:~/clawdbot$ docker-compose up -d
Command 'docker-compose' not found, but can be installed with:
snap install docker          # version 28.4.0, or
apt  install docker-compose  # version 1.29.2-6
See 'snap info docker' for additional versions.
clawdis@Cyrus-Wondura:~/clawdbot$ docker compose up -d
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "TELEGRAM_BOT_TOKEN" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_WEB_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_WEB_COOKIE" variable is not set. Defaulting to a blank string. 
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_AI_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] No services to build                         
[+] up 2/2
 ✔ Container clawdbot-clawdbot-cli-1     Created                                                                                                                                                  0.2s 
 ✔ Container clawdbot-clawdbot-gateway-1 Recreated                                                                                                                                                2.2s 
clawdis@Cyrus-Wondura:~/clawdbot$ docker ps -a
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS                  PORTS                                                                     NAMES
899511a29813   clawdbot:local   "docker-entrypoint.s…"   16 seconds ago   Up 13 seconds           0.0.0.0:18789-18790->18789-18790/tcp, [::]:18789-18790->18789-18790/tcp   clawdbot-clawdbot-gateway-1
648f8d8dcaa2   clawdbot:local   "node dist/index.js"     16 seconds ago   Up 13 seconds                                                                                     clawdbot-clawdbot-cli-1
1ec67bac3f4f   hello-world      "/hello"                 2 days ago       Exited (0) 2 days ago                                                                             nice_kalam
clawdis@Cyrus-Wondura:~/clawdbot$ docker compose run --rm clawdbot-cli onboard
WARN[0000] The "TELEGRAM_BOT_TOKEN" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_WEB_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_WEB_COOKIE" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_AI_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] No services to build                         
WARN[0000] No services to build                         
Container clawdbot-clawdbot-cli-run-2d68e60be6ba Creating 
Container clawdbot-clawdbot-cli-run-2d68e60be6ba Created 

🦞 Clawdbot 2026.1.10 (unknown) — WhatsApp, but make it ✨engineering✨.

░████░█░░░░░█████░█░░░█░███░░████░░████░░▀█▀
█░░░░░█░░░░░█░░░█░█░█░█░█░░█░█░░░█░█░░░█░░█░
█░░░░░█░░░░░█████░█░█░█░█░░█░████░░█░░░█░░█░
█░░░░░█░░░░░█░░░█░█░█░█░█░░█░█░░█░░█░░░█░░█░
░████░█████░█░░░█░░█░█░░███░░████░░░███░░░█░
              🦞 FRESH DAILY 🦞
┌  Clawdbot onboarding
│
◇  Existing config detected ────╮
│                               │
│  workspace: /home/node/clawd  │
│  gateway.mode: local          │
│  gateway.port: 18789          │
│  gateway.bind: loopback       │
│  skills.nodeManager: pnpm     │
│                               │
├───────────────────────────────╯
│
◇  Config handling
│  Update values
│
◇  Onboarding mode
│  QuickStart
│
◇  QuickStart ─────────────────────────────╮
│                                          │
│  Keeping your current gateway settings:  │
│  Gateway port: 18789                     │
│  Gateway bind: Loopback (127.0.0.1)      │
│  Gateway auth: Off (loopback only)       │
│  Tailscale exposure: Off                 │
│  Direct to chat providers.               │
│                                          │
├──────────────────────────────────────────╯
│
◇  Model/auth choice
│  Anthropic token (paste setup-token)
│
◇  Token provider
│  Anthropic (only supported)
│
◇  Anthropic token ────────────────────────────╮
│                                              │
│  Run `claude setup-token` in your terminal.  │
│  Then paste the generated token below.       │
│                                              │
├──────────────────────────────────────────────╯
│
◇  Paste Anthropic setup-token
│  sk-ant-oat01XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
│
◇  Token name (blank = default)
│  default
│
◇  Provider status ──────────────────╮
│                                    │
│  Telegram: needs token             │
│  WhatsApp (default): not linked    │
│  Discord: needs token              │
│  Slack: needs tokens               │
│  Signal: needs setup               │
│  iMessage: needs setup             │
│  signal-cli: missing (signal-cli)  │
│  imsg: missing (imsg)              │
│                                    │
├────────────────────────────────────╯
│
◇  How providers work ────────────────────────────────────────────────────────────────────╮
│                                                                                         │
│  DM security: default is pairing; unknown DMs get a pairing code.                       │
│  Approve with: clawdbot pairing approve --provider <provider> <code>                    │
│  Public DMs require dmPolicy="open" + allowFrom=["*"].                                  │
│  Docs: start/pairing                                                                    │
│                                                                                         │
│  Telegram: simplest way to get started — register a bot with @BotFather and get going.  │
│  WhatsApp: works with your own number; recommend a separate phone + eSIM.               │
│  Discord: very well supported right now.                                                │
│  Slack: supported (Socket Mode).                                                        │
│  Signal: signal-cli linked device; more setup (David Reagans: "Hop on Discord.").       │
│  iMessage: this is still a work in progress.                                            │
│  MS Teams: supported (Bot Framework).                                                   │
│                                                                                         │
├─────────────────────────────────────────────────────────────────────────────────────────╯
│
◇  Select provider (QuickStart)
│  Telegram (Bot API)
│
◇  Selected providers ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                                                                            │
│  Telegram — simplest way to get started — register a bot with @BotFather and get going. https://docs.clawd.bot/telegram https://clawd.bot  │
│                                                                                                                                            │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
│
◇  Telegram bot token ────────────────────────────────────╮
│                                                         │
│  1) Open Telegram and chat with @BotFather              │
│  2) Run /newbot (or /mybots)                            │
│  3) Copy the token (looks like 123456:ABC...)           │
│  Tip: you can also set TELEGRAM_BOT_TOKEN in your env.  │
│  Docs: https://docs.clawd.bot/telegram                  │
│  Website: https://clawd.bot                             │
│                                                         │
├─────────────────────────────────────────────────────────╯
│
◇  Enter Telegram bot token
│  853XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
│
◇  Telegram allowFrom (user id)
│  883350587
Updated /home/node/.clawdbot/clawdbot.json
Workspace OK: /home/node/clawd
Sessions OK: /home/node/.clawdbot/agents/main/sessions
│
◇  Skills status ────────────╮
│                            │
│  Eligible: 6               │
│  Missing requirements: 43  │
│  Blocked by allowlist: 0   │
│                            │
├────────────────────────────╯
│
◇  Configure skills now? (recommended)
│  Yes
│
◇  Homebrew recommended ──────────────────────────────────────────────────────────╮
│                                                                                 │
│  Many skill dependencies are shipped via Homebrew.                              │
│  Without brew, you'll need to build from source or download releases manually.  │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────╯
│
◇  Show Homebrew install command?
│  Yes
│
◇  Homebrew install ────────────────────────────────────────────────────────────────────────────────╮
│                                                                                                   │
│  Run:                                                                                             │
│  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  │
│                                                                                                   │
├───────────────────────────────────────────────────────────────────────────────────────────────────╯
│
◇  Preferred node manager for skill installs
│  pnpm
│
◇  Install missing skill dependencies
│  Skip for now
│
◇  Set BRAVE_API_KEY for brave-search?
│  Yes
│
◇  Enter BRAVE_API_KEY
│  BSXXXXXXXXXXXXXXXXXXXXXXX
│
◇  Set GOOGLE_PLACES_API_KEY for goplaces?
│  No
│
◇  Set GOOGLE_PLACES_API_KEY for local-places?
│  No
│
◇  Set GEMINI_API_KEY for nano-banana-pro?
│  No
│
◇  Set OPENAI_API_KEY for openai-image-gen?
│  No
│
◇  Set OPENAI_API_KEY for openai-whisper-api?
│  No
│
◇  Set ELEVENLABS_API_KEY for sag?
│  No
│
◇  Systemd ──────────────────────────────────────────────────────────────────────────────╮
│                                                                                        │
│  Systemd user services are unavailable. Skipping lingering checks and daemon install.  │
│                                                                                        │
├────────────────────────────────────────────────────────────────────────────────────────╯
Health check failed: gateway closed (1006 abnormal closure (no close frame)): no close reason
  Gateway target: ws://127.0.0.1:18789
  Source: local loopback
  Config: /home/node/.clawdbot/clawdbot.json
  Bind: loopback
│
◇  Health check help ──────────────────────────────╮
│                                                  │
│  Docs:                                           │
│  https://docs.clawd.bot/gateway/health           │
│  https://docs.clawd.bot/gateway/troubleshooting  │
│                                                  │
├──────────────────────────────────────────────────╯
│
◇  Optional apps ────────────────────────╮
│                                        │
│  Add nodes for extra features:         │
│  - macOS app (system + notifications)  │
│  - iOS app (camera/canvas)             │
│  - Android app (camera/canvas)         │
│                                        │
├────────────────────────────────────────╯
│
◇  Control UI ───────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                                    │
│  Web UI: http://127.0.0.1:18789/                                                                   │
│  Gateway WS: ws://127.0.0.1:18789                                                                  │
│  Gateway: not detected (gateway closed (1006 abnormal closure (no close frame)): no close reason)  │
│  Docs: https://docs.clawd.bot/web/control-ui                                                       │
│                                                                                                    │
├────────────────────────────────────────────────────────────────────────────────────────────────────╯
│
◇  Workspace backup ──────────────────────────────────────╮
│                                                         │
│  Back up your agent workspace.                          │
│  Docs: https://docs.clawd.bot/concepts/agent-workspace  │
│                                                         │
├─────────────────────────────────────────────────────────╯
│
└  Onboarding complete.

clawdis@Cyrus-Wondura:~/clawdbot$   docker compose -f /home/clawdis/clawdbot/docker-compose.yml logs -f clawdbot-gateway
WARN[0000] The "CLAUDE_WEB_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_WEB_COOKIE" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "TELEGRAM_BOT_TOKEN" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "CLAUDE_AI_SESSION_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GOOGLE_PLACES_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "BRAVE_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "GEMINI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "OPENAI_API_KEY" variable is not set. Defaulting to a blank string. 
WARN[0000] The "ELEVENLABS_API_KEY" variable is not set. Defaulting to a blank string. 
clawdbot-gateway-1  | [canvas] canvas host mounted at http://0.0.0.0:18789/__clawdbot__/canvas/ (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [canvas] canvas host listening on http://0.0.0.0:18793 (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [bridge] listening on tcp://0.0.0.0:18790 (node)
clawdbot-gateway-1  | [heartbeat] heartbeat: started
clawdbot-gateway-1  | [gateway] agent model: anthropic/claude-opus-4-5
clawdbot-gateway-1  | [gateway] listening on ws://0.0.0.0:18789 (PID 7)
clawdbot-gateway-1  | [gateway] log file: /tmp/clawdbot/clawdbot-2026-01-11.log
clawdbot-gateway-1  | [browser/server] Browser control listening on http://127.0.0.1:18791/
clawdbot-gateway-1  | [whatsapp] [default] skipping provider start (no linked session)
clawdbot-gateway-1  | [reload] config change detected; evaluating reload (agents.defaults.contextPruning, agents.list, telegram.botToken)
clawdbot-gateway-1  | [gateway/providers] restarting telegram provider
clawdbot-gateway-1  | [telegram] [default] starting provider (@kinan_clawdbot_bot)
clawdbot-gateway-1  | [reload] config hot reload applied (telegram.botToken)
clawdbot-gateway-1  | [reload] config change detected; evaluating reload (wizard.lastRunAt, agents.list, skills.entries.brave-search.apiKey)
clawdbot-gateway-1  | [reload] config change applied (dynamic reads: wizard.lastRunAt, agents.list, skills.entries.brave-search.apiKey)
clawdbot-gateway-1  | [clawdbot] Uncaught exception: Error: spawn docker ENOENT
clawdbot-gateway-1  |     at Process.ChildProcess._handle.onexit (node:internal/child_process:285:19)
clawdbot-gateway-1  |     at onErrorNT (node:internal/child_process:483:16)
clawdbot-gateway-1  |     at processTicksAndRejections (node:internal/process/task_queues:90:21)
clawdbot-gateway-1 exited with code 1 (restarting)
clawdbot-gateway-1  | [canvas] canvas host mounted at http://0.0.0.0:18789/__clawdbot__/canvas/ (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [canvas] canvas host listening on http://0.0.0.0:18793 (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [bridge] listening on tcp://0.0.0.0:18790 (node)
clawdbot-gateway-1  | [heartbeat] heartbeat: started
clawdbot-gateway-1  | [gateway] agent model: anthropic/claude-opus-4-5
clawdbot-gateway-1  | [gateway] listening on ws://0.0.0.0:18789 (PID 8)
clawdbot-gateway-1  | [gateway] log file: /tmp/clawdbot/clawdbot-2026-01-11.log
clawdbot-gateway-1  | [browser/server] Browser control listening on http://127.0.0.1:18791/
clawdbot-gateway-1  | [whatsapp] [default] skipping provider start (no linked session)
clawdbot-gateway-1  | [telegram] [default] starting provider (@kinan_clawdbot_bot)
clawdbot-gateway-1  | [clawdbot] Uncaught exception: Error: spawn docker ENOENT
clawdbot-gateway-1  |     at Process.ChildProcess._handle.onexit (node:internal/child_process:285:19)
clawdbot-gateway-1  |     at onErrorNT (node:internal/child_process:483:16)
clawdbot-gateway-1  |     at processTicksAndRejections (node:internal/process/task_queues:90:21)
clawdbot-gateway-1 exited with code 1 (restarting)
clawdbot-gateway-1  | [canvas] canvas host mounted at http://0.0.0.0:18789/__clawdbot__/canvas/ (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [canvas] canvas host listening on http://0.0.0.0:18793 (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [bridge] listening on tcp://0.0.0.0:18790 (node)
clawdbot-gateway-1  | [heartbeat] heartbeat: started
clawdbot-gateway-1  | [gateway] agent model: anthropic/claude-opus-4-5
clawdbot-gateway-1  | [gateway] listening on ws://0.0.0.0:18789 (PID 6)
clawdbot-gateway-1  | [gateway] log file: /tmp/clawdbot/clawdbot-2026-01-11.log
clawdbot-gateway-1  | [browser/server] Browser control listening on http://127.0.0.1:18791/
clawdbot-gateway-1  | [whatsapp] [default] skipping provider start (no linked session)
clawdbot-gateway-1  | [telegram] [default] starting provider (@kinan_clawdbot_bot)
clawdbot-gateway-1  | [clawdbot] Uncaught exception: Error: spawn docker ENOENT
clawdbot-gateway-1  |     at Process.ChildProcess._handle.onexit (node:internal/child_process:285:19)
clawdbot-gateway-1  |     at onErrorNT (node:internal/child_process:483:16)
clawdbot-gateway-1  |     at processTicksAndRejections (node:internal/process/task_queues:90:21)
clawdbot-gateway-1 exited with code 1 (restarting)
clawdbot-gateway-1  | [canvas] canvas host mounted at http://0.0.0.0:18789/__clawdbot__/canvas/ (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [canvas] canvas host listening on http://0.0.0.0:18793 (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [bridge] listening on tcp://0.0.0.0:18790 (node)
clawdbot-gateway-1  | [heartbeat] heartbeat: started
clawdbot-gateway-1  | [gateway] agent model: anthropic/claude-opus-4-5
clawdbot-gateway-1  | [gateway] listening on ws://0.0.0.0:18789 (PID 7)
clawdbot-gateway-1  | [gateway] log file: /tmp/clawdbot/clawdbot-2026-01-11.log
clawdbot-gateway-1  | [browser/server] Browser control listening on http://127.0.0.1:18791/
clawdbot-gateway-1  | [whatsapp] [default] skipping provider start (no linked session)
clawdbot-gateway-1  | [telegram] [default] starting provider (@kinan_clawdbot_bot)
clawdbot-gateway-1  | [clawdbot] Uncaught exception: Error: spawn docker ENOENT
clawdbot-gateway-1  |     at Process.ChildProcess._handle.onexit (node:internal/child_process:285:19)
clawdbot-gateway-1  |     at onErrorNT (node:internal/child_process:483:16)
clawdbot-gateway-1  |     at processTicksAndRejections (node:internal/process/task_queues:90:21)
clawdbot-gateway-1 exited with code 1 (restarting)
clawdbot-gateway-1  | [canvas] canvas host mounted at http://0.0.0.0:18789/__clawdbot__/canvas/ (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [canvas] canvas host listening on http://0.0.0.0:18793 (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [bridge] listening on tcp://0.0.0.0:18790 (node)
clawdbot-gateway-1  | [heartbeat] heartbeat: started
clawdbot-gateway-1  | [gateway] agent model: anthropic/claude-opus-4-5
clawdbot-gateway-1  | [gateway] listening on ws://0.0.0.0:18789 (PID 8)
clawdbot-gateway-1  | [gateway] log file: /tmp/clawdbot/clawdbot-2026-01-11.log
clawdbot-gateway-1  | [browser/server] Browser control listening on http://127.0.0.1:18791/
clawdbot-gateway-1  | [whatsapp] [default] skipping provider start (no linked session)
clawdbot-gateway-1  | [telegram] [default] starting provider (@kinan_clawdbot_bot)
clawdbot-gateway-1  | [clawdbot] Uncaught exception: Error: spawn docker ENOENT
clawdbot-gateway-1  |     at Process.ChildProcess._handle.onexit (node:internal/child_process:285:19)
clawdbot-gateway-1  |     at onErrorNT (node:internal/child_process:483:16)
clawdbot-gateway-1  |     at processTicksAndRejections (node:internal/process/task_queues:90:21)
clawdbot-gateway-1 exited with code 1 (restarting)
clawdbot-gateway-1  | [canvas] canvas host mounted at http://0.0.0.0:18789/__clawdbot__/canvas/ (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [canvas] canvas host listening on http://0.0.0.0:18793 (root /home/node/clawd/canvas)
clawdbot-gateway-1  | [bridge] listening on tcp://0.0.0.0:18790 (node)
clawdbot-gateway-1  | [heartbeat] heartbeat: started
clawdbot-gateway-1  | [gateway] agent model: anthropic/claude-opus-4-5
clawdbot-gateway-1  | [gateway] listening on ws://0.0.0.0:18789 (PID 7)
clawdbot-gateway-1  | [gateway] log file: /tmp/clawdbot/clawdbot-2026-01-11.log
clawdbot-gateway-1  | [browser/server] Browser control listening on http://127.0.0.1:18791/
clawdbot-gateway-1  | [whatsapp] [default] skipping provider start (no linked session)
clawdbot-gateway-1  | [telegram] [default] starting provider (@kinan_clawdbot_bot)
clawdbot-gateway-1  | [clawdbot] Uncaught exception: Error: spawn docker ENOENT
clawdbot-gateway-1  |     at Process.ChildProcess._handle.onexit (node:internal/child_process:285:19)
clawdbot-gateway-1  |     at onErrorNT (node:internal/child_process:483:16)
clawdbot-gateway-1  |     at processTicksAndRejections (node:internal/process/task_queues:90:21)
clawdbot-gateway-1 exited with code 1 (restarting)
^C

but i still see them in the clawdbot.json why?!!!! what is wrong??! please reviwe this and tell me the correct way to do it @/docker-compose.yml  
@/docs/cli/sandbox.md @/docs/install/docker.md