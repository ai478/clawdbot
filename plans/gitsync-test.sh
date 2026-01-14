#!/usr/bin/env bash
# GitSync Workflow Test Script
# This script tests the GitSync agent configuration

set -e

echo "=== GitSync Configuration Test ==="
echo ""

# Test 1: Validate JSON configuration
echo "Test 1: Validating clawdbot.json.new..."
if command -v jq &> /dev/null; then
    if jq empty clawdbot.json.new 2>/dev/null; then
        echo "✓ JSON is valid"
    else
        echo "✗ JSON is invalid"
        exit 1
    fi
else
    echo "⚠ jq not found - skipping JSON validation"
fi

# Test 2: Check gitsync agent exists
echo ""
echo "Test 2: Checking for gitsync agent..."
if grep -q '"id": "gitsync"' clawdbot.json.new; then
    echo "✓ gitsync agent found in configuration"
else
    echo "✗ gitsync agent not found"
    exit 1
fi

# Test 3: Check sandbox mode is off
echo ""
echo "Test 3: Checking sandbox mode..."
if grep -A5 '"id": "gitsync"' clawdbot.json.new | grep -q '"mode": "off"'; then
    echo "✓ Sandbox mode is off (safe)"
else
    echo "⚠ Sandbox mode may not be 'off'"
fi

# Test 4: Check soul file exists
echo ""
echo "Test 4: Checking soul file..."
if [ -f "plans/gitsync-soul.md" ]; then
    echo "✓ Soul file exists at plans/gitsync-soul.md"
    
    # Check for key safety rules
    if grep -q "NEVER merge" plans/gitsync-soul.md; then
        echo "✓ Safety rule found: NEVER merge"
    fi
    if grep -q "scripts/committer" plans/gitsync-soul.md; then
        echo "✓ Committer script reference found"
    fi
    if grep -q "v1" plans/gitsync-soul.md; then
        echo "✓ v1 remote reference found"
    fi
else
    echo "✗ Soul file not found"
    exit 1
fi

# Test 5: Display example usage
echo ""
echo "=== Example Usage ==="
echo ""
echo "To use the GitSync agent, run:"
echo ""
echo "  # Start a gitsync session"
echo "  clawdbot agent --session gitsync --message '"
echo "    Create a branch called update-readme, "
echo "    edit README.md, commit the changes, "
echo "    and push to v1 remote"
echo "  '"
echo ""
echo "Or via Telegram:"
echo "  @clawdbot in Telegram"
echo ""

echo "=== Test Complete ==="
