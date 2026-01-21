#!/bin/bash
# Codex completion callback script with dual notifications
# Usage: codex-with-callback.sh [--agent AGENT] [--user TELEGRAM_ID] [--broadcast] -- <codex args>

set -e

# ============================================
# Configuration from Environment
# ============================================
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
DEFAULT_AGENT="${CLAWDBOT_DEFAULT_AGENT:-admin}"
CLAWDBOT_GATEWAY_URL="${CLAWDBOT_GATEWAY_URL:-http://localhost:18789}"

# ============================================
# Parse Arguments
# ============================================
AGENT="$DEFAULT_AGENT"
TELEGRAM_USER=""
BROADCAST_TO_BOTH_AGENTS=false

# Parse custom flags before --
while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent)
      AGENT="$2"
      shift 2
      ;;
    --user)
      TELEGRAM_USER="$2"
      shift 2
      ;;
    --broadcast)
      # This will wake BOTH admin and team agents
      BROADCAST_TO_BOTH_AGENTS=true
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      # No more flags, everything else is for codex
      break
      ;;
  esac
done

# Remaining args are for codex
CODEX_ARGS="$@"
TASK_SUMMARY="$*"

# Validate
if [ -z "$TASK_SUMMARY" ]; then
  echo "❌ Error: No codex command provided"
  echo "Usage: codex-with-callback.sh [--agent AGENT] [--user TELEGRAM_ID] [--broadcast] -- <codex args>"
  exit 1
fi

# ============================================
# Run Codex
# ============================================
echo "═══════════════════════════════════════════════════════"
echo "🚀 Starting Codex"
echo "   Agent: ${AGENT}"
echo "   Broadcast: ${BROADCAST_TO_BOTH_AGENTS}"
echo "   Task: ${TASK_SUMMARY}"
echo "═══════════════════════════════════════════════════════"

START_TIME=$(date +%s)

# Run codex and capture exit code
codex exec $CODEX_ARGS
EXIT_CODE=$?

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# ============================================
# Log Completion
# ============================================
LOG_DIR="/tmp/codex-logs"
mkdir -p "$LOG_DIR"
echo "$(date -Iseconds): [${AGENT}] ${TASK_SUMMARY} -> Exit ${EXIT_CODE} (${DURATION}s)" \
  >> "${LOG_DIR}/codex-completion.log"

# ============================================
# Prepare Messages
# ============================================
if [ ${EXIT_CODE} -eq 0 ]; then
  STATUS_EMOJI="✅"
  STATUS_TEXT="completed successfully"
  WAKE_MESSAGE="✅ Codex completed successfully (${DURATION}s): ${TASK_SUMMARY}"
else
  STATUS_EMOJI="❌"
  STATUS_TEXT="failed with exit code ${EXIT_CODE}"
  WAKE_MESSAGE="❌ Codex failed with exit code ${EXIT_CODE} (${DURATION}s): ${TASK_SUMMARY}"
fi

echo ""
echo "${STATUS_EMOJI} Codex ${STATUS_TEXT} in ${DURATION}s"

# ============================================
# Function: Wake Agent via CLI
# ============================================
wake_agent() {
  local target_agent="$1"
  local message="$2"
  
  echo "📡 Waking ${target_agent} agent..."
  
  # Use clawdbot CLI to wake the agent
  if clawdbot wake --text "${message}" --mode now --agent "${target_agent}" 2>/dev/null; then
    echo "   ✓ ${target_agent} agent notified"
    return 0
  else
    echo "   ⚠️  Failed to wake ${target_agent} agent (clawdbot CLI not available or failed)"
    return 1
  fi
}

# ============================================
# Wake Agent(s)
# ============================================
echo ""
echo "🔔 Notifying agent(s)..."

if [ "$BROADCAST_TO_BOTH_AGENTS" = true ]; then
  # Wake both admin and team agents
  wake_agent "admin" "${WAKE_MESSAGE}"
  wake_agent "team" "${WAKE_MESSAGE}"
else
  # Wake only the specified agent
  wake_agent "${AGENT}" "${WAKE_MESSAGE}"
fi

# ============================================
# Send Telegram Notification to User
# ============================================
if [ -n "$TELEGRAM_USER" ] && [ -n "$TELEGRAM_BOT_TOKEN" ]; then
  echo ""
  echo "📱 Sending Telegram notification to user ${TELEGRAM_USER}..."
  
  # Prepare Telegram message
  if [ ${EXIT_CODE} -eq 0 ]; then
    TELEGRAM_TEXT="${STATUS_EMOJI} *Codex Completed*%0A%0A"
    TELEGRAM_TEXT="${TELEGRAM_TEXT}🎯 *Task:* \`${TASK_SUMMARY}\`%0A"
    TELEGRAM_TEXT="${TELEGRAM_TEXT}⏱ *Duration:* ${DURATION}s%0A"
    TELEGRAM_TEXT="${TELEGRAM_TEXT}🤖 *Agent:* ${AGENT}%0A"
    if [ "$BROADCAST_TO_BOTH_AGENTS" = true ]; then
      TELEGRAM_TEXT="${TELEGRAM_TEXT}📡 *Broadcast:* admin + team%0A"
    fi
    TELEGRAM_TEXT="${TELEGRAM_TEXT}%0AThe agent has been notified and is processing the results."
  else
    TELEGRAM_TEXT="${STATUS_EMOJI} *Codex Failed*%0A%0A"
    TELEGRAM_TEXT="${TELEGRAM_TEXT}🎯 *Task:* \`${TASK_SUMMARY}\`%0A"
    TELEGRAM_TEXT="${TELEGRAM_TEXT}❗ *Exit Code:* ${EXIT_CODE}%0A"
    TELEGRAM_TEXT="${TELEGRAM_TEXT}⏱ *Duration:* ${DURATION}s%0A"
    TELEGRAM_TEXT="${TELEGRAM_TEXT}🤖 *Agent:* ${AGENT}%0A"
    if [ "$BROADCAST_TO_BOTH_AGENTS" = true ]; then
      TELEGRAM_TEXT="${TELEGRAM_TEXT}📡 *Broadcast:* admin + team%0A"
    fi
    TELEGRAM_TEXT="${TELEGRAM_TEXT}%0APlease check the logs for details."
  fi
  
  # Send via Telegram API
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_USER}" \
    -d "text=${TELEGRAM_TEXT}" \
    -d "parse_mode=Markdown")
    
  if [ "$HTTP_CODE" = "200" ]; then
    echo "   ✓ Telegram notification sent!"
  else
    echo "   ⚠️  Failed to send Telegram notification (HTTP ${HTTP_CODE})"
  fi
elif [ -z "$TELEGRAM_USER" ]; then
  echo ""
  echo "ℹ️  No user specified (use --user flag for Telegram notifications)"
elif [ -z "$TELEGRAM_BOT_TOKEN" ]; then
  echo ""
  echo "⚠️  TELEGRAM_BOT_TOKEN not set in environment"
fi

# ============================================
# Summary
# ============================================
echo ""
echo "═══════════════════════════════════════════════════════"
echo "${STATUS_EMOJI} Summary:"
echo "   Exit Code: ${EXIT_CODE}"
echo "   Duration: ${DURATION}s"
echo "   Agent(s) Notified: ${AGENT}$([ "$BROADCAST_TO_BOTH_AGENTS" = true ] && echo " + broadcast")"
echo "   User Notified: $([ -n "$TELEGRAM_USER" ] && echo "Yes (${TELEGRAM_USER})" || echo "No")"
echo "═══════════════════════════════════════════════════════"

exit ${EXIT_CODE}
