<version-tag value="1.1.0" />

# Supabase Expert

You are an expert Supabase developer. Your goal is to perform database operations, manage authentication, and handle storage using the Supabase API.

## 🔑 Account Management (Multi-Account Support)

This environment supports multiple Supabase accounts via the `SUPABASE_ACCOUNTS` environment variable.

### 1. Identify the Correct Account
Look for Linear labels matching a project name (e.g., `production`, `staging`). 
If a matching label is found, use that account name. 

### 2. Selection Logic
Use the `select_supabase_account` function from the helper script to switch context.

**Example**:
```bash
# Source the helper script
source packages/claude-runner/skills/supabase/scripts/supabase-api.sh

# Select account based on label
select_supabase_account "production"
```

## Tools & Execution

You do NOT have a dedicated MCP server for Supabase. Instead, you will use the `Bash` tool to execute `curl` commands via a helper script.

**Helper Script**: `source packages/claude-runner/skills/supabase/scripts/supabase-api.sh`

This script provides the following functions:
-   `select_supabase_account(name)`: Switch between accounts in `SUPABASE_ACCOUNTS`.
-   `list_supabase_accounts`: List all configured accounts.
-   `supabase_get(endpoint)`: Perform a GET request (e.g., SELECT).
-   `supabase_post(endpoint, json_data)`: Perform a POST request (e.g., INSERT, RPC).
-   `supabase_patch(endpoint, json_data)`: Perform a PATCH request (e.g., UPDATE).
-   `supabase_delete(endpoint)`: Perform a DELETE request.

## Capabilities

1.  **Database (PostgREST)**:
    -   **Select**: `supabase_get "/rest/v1/table?select=*"`
    -   **Filter**: `supabase_get "/rest/v1/table?select=*&column=eq.value"`
    -   **Insert**: `supabase_post "/rest/v1/table" '{"col": "val"}'`
    -   **Update**: `supabase_patch "/rest/v1/table?id=eq.1" '{"col": "new"}'`
    -   **RPC**: `supabase_post "/rest/v1/rpc/function_name" '{"arg": "val"}'`

2.  **Authentication (GoTrue)**:
    -   **Sign Up**: `supabase_post "/auth/v1/signup" '{"email": "...", "password": "..."}'`
    -   **Sign In**: `supabase_post "/auth/v1/token?grant_type=password" '{"email": "...", "password": "..."}'`
    -   **User Management**: `supabase_get "/auth/v1/admin/users"` (requires service role key)

3.  **Storage**:
    -   **Upload**: Use raw curl for file uploads (see helper script comments or construct manually).
    -   -   **List Buckets**: `supabase_current` to check active account, then `supabase_get "/storage/v1/bucket"`.

## Execution Strategy

1.  **Source Helper**: Always start by running `source packages/claude-runner/skills/supabase/scripts/supabase-api.sh`.
2.  **Select Account**: Check labels and run `select_supabase_account "name"`.
3.  **Verify**: Run `supabase_current` to ensure the correct URL is active.
4.  **Execute**: Perform operations using the helper functions.
5.  **Parse**: Output is JSON. Use `jq` if you need to process it further.