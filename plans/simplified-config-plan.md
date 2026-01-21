# Option A Plan - Simplified Configuration (No Sandbox)

## Goal

Simplify Clawdbot by removing sandbox container, using main container with tool restrictions and volume mount permissions.

## Changes Overview

### 1. Update `clawdbot.json.new`

- Set `sandbox.mode: "off"` for all agents
- Keep admin/team agent differentiation via bindings
- Configure tool allow/deny policies
- Add Codex CLI access configuration

### 2. Update `docker-compose.yml`

- Add Codex auth mount
- Add skills mount
- Keep network access (no sandbox complexity)

### 3. Fix Telegram Group Issue

- Group ID `-5211821786` already in config but bot not responding
- Need to check bot permissions in Telegram

---

## Configuration Changes

### clawdbot.json.new - Simplified Sandbox Settings

```json
{
  "agents": {
    "defaults": {
      "workspace": "/home/node/clawd",
      "sandbox": {
        "mode": "off"
      }
    },
    "list": [
      {
        "id": "admin",
        "workspace": "/home/node/clawd",
        "identity": {
          "name": "Stevie",
          "theme": "Strategic mind — part Jobs, part Musk. Direct, opinionated, truth-telling. Expert in n8n automation (using n8n-mcp tools) and Supabase database/storage management (using supabase-api.sh helper). Highly efficient, prefers parallel execution, and always validates node configurations explicitly.",
          "emoji": "🚀"
        },
        "sandbox": {
          "mode": "off"
        }
      },
      {
        "id": "team",
        "workspace": "/home/node/clawd-team",
        "identity": {
          "name": "Stevie Team",
          "theme": "Strategic mind - Team version. Respectful but efficient. Expert in n8n automation and Supabase operations. I cannot modify my own soul or workspace; for any systemic changes, I will suggest checking with Kinan or Abdalrahman for admin approval. I can recognize team members vs admins by checking IDs in `/bot-config/clawdbot.json`. I have access to a shared directory at `/shared` (persistent across sessions) for collaboration.",
          "emoji": "👥"
        },
        "sandbox": {
          "mode": "off"
        }
      }
    ]
  },
  "tools": {
    "sandbox": {
      "tools": {
        "allow": [],
        "deny": ["browser", "canvas", "nodes", "cron", "discord", "gateway"]
      }
    }
  }
}
```

### docker-compose.yml - Updated Volume Mounts

```yaml
services:
  clawdbot-gateway:
    # ... existing config ...
    volumes:
      - ${CLAWDBOT_CONFIG_DIR}:/home/node/.clawdbot
      - /home/clawdis/clawd:/home/node/clawd
      - /home/clawdis/clawd-team:/home/node/clawd-team
      - /home/clawdis/shared:/home/node/shared
      - /home/clawdis/shared/skills:/home/node/.clawdbot/skills
      - /home/clawdis/.codex/auth.json:/home/node/.codex/auth.json:ro # Codex OAuth
      - /var/run/docker.sock:/var/run/docker.sock
    # ... rest of config ...
```

---

## Telegram Group Issue - Diagnosis & Fix

### Current Configuration (Working)

```json
{
  "bindings": [
    {
      "agentId": "team",
      "match": {
        "channel": "telegram",
        "peer": {
          "kind": "group",
          "id": "-5211821786"
        }
      }
    }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "allowlist",
      "allowFrom": [
        "883350587",
        "1383989988",
        "8346495442",
        "6519362897",
        "822984553",
        "892973720",
        "5148176939",
        "-5211821786" // Group ID here
      ],
      "groupPolicy": "open",
      "streamMode": "partial"
    }
  }
}
```

### Potential Issues

1. **Bot Privacy Mode in Groups**

   - By default, bots can't see all messages in groups
   - Need to disable "Group Privacy" in BotFather

2. **Bot Permissions in Group**

   - Bot needs these permissions:
     - Read all messages
     - Send messages
     - Add web pages to messages (for inline tools)

3. **Bot Not Added as Admin**
   - Group admin can add bot as regular member
   - But bot needs "Group Privacy" turned OFF to see all messages

### Fix Steps

**Step 1: Check BotFather Settings**

```bash
# Message BotFather on Telegram
/setprivacy  # Correct command (not /privacy)
# Select your bot
# Choose "Disable" to let bot see all messages in groups
```

**Alternative: Use Bot API directly**

```bash
curl -X POST "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/setChatPermissions"
  -d "{\"chat_id\": \"@<YOUR_BOT_USERNAME>\", \"permissions\":{\"can_read_messages\":true,\"can_send_messages\":true}}"
```

**Step 2: Disable Group Privacy**
In BotFather, disable "Group Privacy" so the bot can see all messages in groups.

**Step 3: Verify Bot Permissions in Group**
In Telegram group settings > Manage group > Administrators:

- Ensure bot has "Read all messages" permission
- Ensure bot has "Send messages" permission

**Step 4: Restart Clawdbot**

```bash
clawdbot doctor
# Or restart the gateway service
docker-compose restart clawdbot-gateway
```

### If Still Not Working

Check the logs for errors:

```bash
# View gateway logs
clawdbot doctor --verbose

# Or check Docker logs
docker logs clawdbot-gateway
```

---

## Implementation Steps

### Step 1: Update clawdbot.json.new

- Set `sandbox.mode: "off"` for all agents
- Remove sandbox-specific docker binds
- Keep tool deny list

### Step 2: Update docker-compose.yml

- Add Codex auth mount (`:ro`)
- Add skills mount
- Verify all volume mounts are correct

### Step 3: Fix Telegram Group

1. Check BotFather privacy settings
2. Disable Group Privacy if needed
3. Verify bot permissions in group
4. Restart clawdbot

### Step 4: Test

- Verify admin agent responds to DMs
- Verify team agent responds in group
- Verify Codex CLI works
- Verify skills are accessible

---

## Files to Modify

| File                 | Changes                             |
| -------------------- | ----------------------------------- |
| `clawdbot.json.new`  | Sandbox mode off, simplified config |
| `docker-compose.yml` | Add Codex and skills mounts         |
| Telegram Group       | Check bot permissions               |

---

## Notes

- Keep old sandbox plan at `plans/sandbox-configuration-plan.md` for future reference
- This simplified approach gives you 90% of sandbox benefits with 10% of complexity
- Tool restrictions still apply via `tools.sandbox.tools.deny`
- Volume mounts control write access (`:ro` vs `:rw`)
