#!/bin/bash
# Supabase API Helper Script with Multi-Account Support
# Provides common functions for making REST API calls to Supabase
# 
# Supports two modes:
# 1. Single account: Set SUPABASE_URL and SUPABASE_KEY directly
# 2. Multi-account: Set SUPABASE_ACCOUNTS as JSON array and use select_supabase_account

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Current selected account name (for display purposes)
SUPABASE_CURRENT_ACCOUNT=""

# List available Supabase accounts from SUPABASE_ACCOUNTS env var
# Usage: list_supabase_accounts
list_supabase_accounts() {
    if [[ -z "${SUPABASE_ACCOUNTS:-}" ]]; then
        echo -e "${YELLOW}No SUPABASE_ACCOUNTS configured. Using SUPABASE_URL/SUPABASE_KEY directly.${NC}"
        if [[ -n "${SUPABASE_URL:-}" ]]; then
            echo -e "${GREEN}Current: ${SUPABASE_URL}${NC}"
        fi
        return 0
    fi

    echo -e "${BLUE}Available Supabase accounts:${NC}"
    echo "$SUPABASE_ACCOUNTS" | jq -r '.[] | "  - \(.name): \(.url)"' 2>/dev/null
    
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Error: Failed to parse SUPABASE_ACCOUNTS. Ensure it is valid JSON.${NC}" >&2
        return 1
    fi
    
    if [[ -n "$SUPABASE_CURRENT_ACCOUNT" ]]; then
        echo -e "${GREEN}Currently selected: $SUPABASE_CURRENT_ACCOUNT${NC}"
    fi
}

# Select a Supabase account from SUPABASE_ACCOUNTS by name
# Usage: select_supabase_account "production"
# If no name is provided, lists available accounts
select_supabase_account() {
    local account_name="${1:-}"
    
    # Check if SUPABASE_ACCOUNTS is set
    if [[ -z "${SUPABASE_ACCOUNTS:-}" ]]; then
        echo -e "${YELLOW}SUPABASE_ACCOUNTS not set. Using SUPABASE_URL/SUPABASE_KEY directly.${NC}"
        return 0
    fi
    
    # If no account name provided, list available accounts
    if [[ -z "$account_name" ]]; then
        list_supabase_accounts
        echo ""
        echo "Usage: select_supabase_account <account_name>"
        return 1
    fi
    
    # Parse the account from JSON
    local account_json
    account_json=$(echo "$SUPABASE_ACCOUNTS" | jq -r '.[] | select(.name=="'"$account_name"'")' 2>/dev/null)
    
    if [[ -z "$account_json" ]]; then
        echo -e "${RED}Error: Account '$account_name' not found in SUPABASE_ACCOUNTS${NC}" >&2
        list_supabase_accounts
        return 1
    fi
    
    # Extract URL and key
    local url key
    url=$(echo "$account_json" | jq -r '.url')
    key=$(echo "$account_json" | jq -r '.key')
    
    if [[ -z "$url" || -z "$key" || "$url" == "null" || "$key" == "null" ]]; then
        echo -e "${RED}Error: Invalid account configuration for '$account_name'${NC}" >&2
        return 1
    fi
    
    # Export the environment variables
    export SUPABASE_URL="$url"
    export SUPABASE_KEY="$key"
    SUPABASE_CURRENT_ACCOUNT="$account_name"
    
    echo -e "${GREEN}✓ Selected Supabase account: $account_name${NC}"
    echo -e "${BLUE}  URL: $url${NC}"
    return 0
}

# Get current account info
# Usage: supabase_current
supabase_current() {
    if [[ -n "$SUPABASE_CURRENT_ACCOUNT" ]]; then
        echo -e "${GREEN}Current account: $SUPABASE_CURRENT_ACCOUNT${NC}"
    else
        echo -e "${YELLOW}No account selected via select_supabase_account${NC}"
    fi
    
    if [[ -n "${SUPABASE_URL:-}" ]]; then
        echo -e "${BLUE}URL: $SUPABASE_URL${NC}"
    else
        echo -e "${RED}SUPABASE_URL not set${NC}"
    fi
}

# Validate required environment variables
validate_env() {
    if [[ -z "${SUPABASE_URL}" ]]; then
        echo -e "${RED}Error: SUPABASE_URL environment variable is not set${NC}" >&2
        echo "Please set it with: export SUPABASE_URL='https://your-project.supabase.co'" >&2
        echo "Or use: select_supabase_account <account_name>" >&2
        return 1
    fi

    if [[ -z "${SUPABASE_KEY}" ]]; then
        echo -e "${RED}Error: SUPABASE_KEY environment variable is not set${NC}" >&2
        echo "Please set it with: export SUPABASE_KEY='your-anon-or-service-role-key'" >&2
        echo "Or use: select_supabase_account <account_name>" >&2
        return 1
    fi

    return 0
}

# GET request to Supabase
# Usage: supabase_get "/rest/v1/table_name?select=*"
supabase_get() {
    local endpoint="$1"

    if ! validate_env; then
        return 1
    fi

    curl -s -X GET \
        "${SUPABASE_URL}${endpoint}" \
        -H "apikey: ${SUPABASE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_KEY}" \
        -H "Content-Type: application/json" \
        -w "\n%{http_code}" | {
            local response=$(cat)
            local http_code=$(echo "$response" | tail -n1)
            local body=$(echo "$response" | sed '$d')

            if [[ $http_code -ge 200 && $http_code -lt 300 ]]; then
                echo "$body"
                return 0
            else
                echo -e "${RED}Error: HTTP $http_code${NC}" >&2
                echo "$body" >&2
                return 1
            fi
        }
}

# POST request to Supabase
# Usage: supabase_post "/rest/v1/table_name" '{"column": "value"}'
supabase_post() {
    local endpoint="$1"
    local data="$2"

    if ! validate_env; then
        return 1
    fi

    curl -s -X POST \
        "${SUPABASE_URL}${endpoint}" \
        -H "apikey: ${SUPABASE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_KEY}" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=representation" \
        -d "$data" \
        -w "\n%{http_code}" | {
            local response=$(cat)
            local http_code=$(echo "$response" | tail -n1)
            local body=$(echo "$response" | sed '$d')

            if [[ $http_code -ge 200 && $http_code -lt 300 ]]; then
                echo "$body"
                return 0
            else
                echo -e "${RED}Error: HTTP $http_code${NC}" >&2
                echo "$body" >&2
                return 1
            fi
        }
}

# PATCH request to Supabase
# Usage: supabase_patch "/rest/v1/table_name?id=eq.1" '{"column": "new_value"}'
supabase_patch() {
    local endpoint="$1"
    local data="$2"

    if ! validate_env; then
        return 1
    fi

    curl -s -X PATCH \
        "${SUPABASE_URL}${endpoint}" \
        -H "apikey: ${SUPABASE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_KEY}" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=representation" \
        -d "$data" \
        -w "\n%{http_code}" | {
            local response=$(cat)
            local http_code=$(echo "$response" | tail -n1)
            local body=$(echo "$response" | sed '$d')

            if [[ $http_code -ge 200 && $http_code -lt 300 ]]; then
                echo "$body"
                return 0
            else
                echo -e "${RED}Error: HTTP $http_code${NC}" >&2
                echo "$body" >&2
                return 1
            fi
        }
}

# DELETE request to Supabase
# Usage: supabase_delete "/rest/v1/table_name?id=eq.1"
supabase_delete() {
    local endpoint="$1"

    if ! validate_env; then
        return 1
    fi

    curl -s -X DELETE \
        "${SUPABASE_URL}${endpoint}" \
        -H "apikey: ${SUPABASE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_KEY}" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=representation" \
        -w "\n%{http_code}" | {
            local response=$(cat)
            local http_code=$(echo "$response" | tail -n1)
            local body=$(echo "$response" | sed '$d')

            if [[ $http_code -ge 200 && $http_code -lt 300 ]]; then
                echo "$body"
                return 0
            else
                echo -e "${RED}Error: HTTP $http_code${NC}" >&2
                echo "$body" >&2
                return 1
            fi
        }
}

# Helper to format JSON output (requires jq)
format_json() {
    if command -v jq &> /dev/null; then
        jq '.'
    else
        cat
    fi
}

# Display success message
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Display warning message
warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Display error message
error() {
    echo -e "${RED}✗ $1${NC}" >&2
}
