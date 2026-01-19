#!/bin/bash
# Quick deployment script for scripts to server

echo "📤 Uploading scripts to server..."

# Upload get-employee.sh
scp shared/scripts/get-employee.sh clawdis@your-server:/home/clawdis/shared/scripts/get-employee.sh

# Upload codex-proxy.sh
scp shared/scripts/codex-proxy.sh clawdis@your-server:/home/clawdis/shared/scripts/codex-proxy.sh

echo "✅ Scripts uploaded!"

echo "🔧 Making scripts executable on server..."
ssh clawdis@your-server "chmod +x /home/clawdis/shared/scripts/get-employee.sh /home/clawdis/shared/scripts/codex-proxy.sh"

echo "✅ Scripts are executable!"

echo "🧪 Testing get-employee.sh..."
ssh clawdis@your-server "/home/clawdis/shared/scripts/get-employee.sh 883350587"

echo ""
echo "✅ Done! Scripts are ready to use."
