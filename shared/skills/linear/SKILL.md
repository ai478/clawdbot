---
name: linear
description: "Linear API for creating issues, managing projects, and tracking work. Use for ticket creation, status updates, and commenting."
homepage: https://developers.linear.app
metadata: { "clawdis": { "emoji": "📐" } }
---

# linear

Use the Linear GraphQL API to create/read/update issues, projects, and comments.

## Setup

1. Go to Linear Settings → API → Personal API keys
2. Create a new key with appropriate scopes (read/write issues, comments, projects)
3. Store it:

```bash
mkdir -p ~/.config/linear
echo "lin_api_xxxxx" > ~/.config/linear/api_key
```

## API Basics

Linear uses GraphQL. All requests go to the same endpoint:

```bash
LINEAR_KEY=$(cat ~/.config/linear/api_key)
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ viewer { id name } }"}'
```

## Common Operations

**Get current user and teams:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ viewer { id name email } teams { nodes { id name key } } }"}'
```

**List issues:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ issues(first: 20) { nodes { id identifier title state { name } assignee { name } } } }"}'
```

**Search issues:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "query { issueSearch(query: \"bug\", first: 10) { nodes { id identifier title } } }"}'
```

**Get issue by identifier (e.g., ENG-123):**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "query { issue(id: \"ISSUE_UUID\") { id identifier title description state { name } assignee { name } comments { nodes { body user { name } } } } }"}'
```

**Create issue:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation CreateIssue($input: IssueCreateInput!) { issueCreate(input: $input) { success issue { id identifier title url } } }",
    "variables": {
      "input": {
        "teamId": "TEAM_UUID",
        "title": "Issue title",
        "description": "Full description in markdown",
        "priority": 2
      }
    }
  }'
```

**Add comment to issue:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation CreateComment($input: CommentCreateInput!) { commentCreate(input: $input) { success comment { id body } } }",
    "variables": {
      "input": {
        "issueId": "ISSUE_UUID",
        "body": "Comment text with @mentions"
      }
    }
  }'
```

**Update issue status:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation UpdateIssue($id: String!, $input: IssueUpdateInput!) { issueUpdate(id: $id, input: $input) { success issue { id state { name } } } }",
    "variables": {
      "id": "ISSUE_UUID",
      "input": {
        "stateId": "STATE_UUID"
      }
    }
  }'
```

**Get workflow states (for status updates):**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ workflowStates { nodes { id name type team { name } } } }"}'
```

**Get team projects:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "query { projects(first: 50) { nodes { id name state teams { nodes { name } } } } }"}'
```

**Get labels:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ issueLabels { nodes { id name color } } }"}'
```

## Priority Values

- 0 = No priority
- 1 = Urgent
- 2 = High
- 3 = Medium
- 4 = Low

## Issue Create Input Fields

Common fields for `IssueCreateInput`:

- `teamId` (required): Team UUID
- `title` (required): Issue title
- `description`: Markdown description
- `priority`: 0-4
- `assigneeId`: User UUID
- `labelIds`: Array of label UUIDs
- `projectId`: Project UUID
- `stateId`: Workflow state UUID
- `estimate`: Point estimate

## Mentioning Users in Comments

**⚠️ Plain `@username` in `body` does NOT create real mentions!**

Linear uses ProseMirror document format. To create real mentions that notify users, use `bodyData` instead of `body`:

**Comment with mention using bodyData:**

```bash
curl -X POST "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation CreateComment($input: CommentCreateInput!) { commentCreate(input: $input) { success comment { id body } } }",
    "variables": {
      "input": {
        "issueId": "ISSUE_UUID",
        "bodyData": "{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"suggestion_userMentions\",\"attrs\":{\"id\":\"USER_UUID\",\"label\":\"username\"}},{\"type\":\"text\",\"text\":\" Your message here\"}]}]}"
      }
    }
  }'
```

**Document structure for mentions:**

```json
{
  "type": "doc",
  "content": [
    {
      "type": "paragraph",
      "content": [
        {
          "type": "suggestion_userMentions",
          "attrs": {
            "id": "USER_UUID",
            "label": "displayName"
          }
        },
        {
          "type": "text",
          "text": " Rest of your comment"
        }
      ]
    }
  ]
}
```

**User IDs for Wonderbeauties team:**
| Name | ID | displayName |
|------|-----|-------------|
| Cursor | `be11ea03-bfd6-454d-af46-b08bb3d6ba71` | cursor |
| Cyrus | `81b4b2f6-4105-42b4-8bbf-35bb5fd23816` | cyrus |
| Kinan Zayat | `c9b7529a-4ef4-4321-a0d9-0ce8046bd7d3` | ai |

**Helper function (PowerShell):**

```powershell
function New-LinearMention {
    param($userId, $label, $message)
    $doc = @{
        type = "doc"
        content = @(
            @{
                type = "paragraph"
                content = @(
                    @{
                        type = "suggestion_userMentions"
                        attrs = @{ id = $userId; label = $label }
                    },
                    @{ type = "text"; text = " $message" }
                )
            }
        )
    }
    return ($doc | ConvertTo-Json -Depth 10 -Compress)
}
```

## Notes

- All IDs are UUIDs
- Use `identifier` (e.g., ENG-123) for display, `id` (UUID) for API calls
- Rate limit: 1500 requests per hour
- Pagination: Use `first`, `after` for cursor-based pagination
- All text fields support Markdown
