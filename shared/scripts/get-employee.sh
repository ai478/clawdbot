#!/bin/bash
# Get employee information from Supabase
# Usage: get-employee.sh <telegram_id>

TELEGRAM_ID="$1"

if [ -z "$TELEGRAM_ID" ]; then
  echo '{"error":"Telegram ID is required"}'
  exit 1
fi

# Check if owner (hardcoded)
if [ "$TELEGRAM_ID" = "883350587" ] || [ "$TELEGRAM_ID" = "1383989988" ]; then
  cat <<EOF
{
  "id": "owner",
  "name": "Owner",
  "telegram_id": "$TELEGRAM_ID",
  "role": "owner",
  "position": "Owner",
  "status": "active"
}
EOF
  exit 0
fi

# Query Supabase
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
  echo '{"error":"Supabase credentials not configured"}'
  exit 1
fi

# Search for employee by phone (telegram_id might be in mobile_whatsapp field)
RESULT=$(curl -s "${SUPABASE_URL}/rest/v1/employees?mobile_whatsapp=like.*${TELEGRAM_ID}*&select=id,full_name,mobile_whatsapp,status,position:positions(title)" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/json")

# Check if employee found
if [ "$(echo "$RESULT" | jq 'length')" = "0" ]; then
  echo '{"error":"Employee not found in database","telegram_id":"'$TELEGRAM_ID'"}'
  exit 1
fi

# Extract data
ID=$(echo "$RESULT" | jq -r '.[0].id')
NAME=$(echo "$RESULT" | jq -r '.[0].full_name')
POSITION=$(echo "$RESULT" | jq -r '.[0].position.title')
STATUS=$(echo "$RESULT" | jq -r '.[0].status')

# Map position to role (for LLM context)
if echo "$POSITION" | grep -qiE '^(cto|head of|manager|visionary|integrator|regional)'; then
  ROLE="manager"
elif echo "$POSITION" | grep -qi 'lead'; then
  ROLE="lead"
else
  ROLE="employee"
fi

# Output JSON
cat <<EOF
{
  "id": "$ID",
  "name": "$NAME",
  "telegram_id": "$TELEGRAM_ID",
  "role": "$ROLE",
  "position": "$POSITION",
  "status": "$STATUS"
}
EOF
