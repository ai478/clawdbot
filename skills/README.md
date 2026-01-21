# Cyrus Claude Code Skills

This directory contains skills for Claude Code that extend its capabilities to work with n8n workflows and Supabase databases.

## Overview

Skills are discovered automatically by Claude Code via SKILL.md files with YAML frontmatter. Each skill provides expert guidance on a specific topic.

## Available Skills

### n8n Skills (7 skills)
- **n8n-code-javascript** - Write JavaScript in n8n Code nodes
- **n8n-code-python** - Write Python in n8n Code nodes
- **n8n-expression-syntax** - n8n expression syntax ({{}} patterns)
- **n8n-mcp-tools-expert** - Expert guide for n8n-mcp MCP tools
- **n8n-node-configuration** - Operation-aware node configuration
- **n8n-validation-expert** - Interpret validation errors
- **n8n-workflow-patterns** - Workflow architectural patterns

### Supabase Skills (5 skills)
- **supabase-auth** - Authentication and user management
- **supabase-database** - CRUD operations via REST API
- **supabase-edge-functions** - Serverless function deployment
- **supabase-realtime** - WebSocket subscriptions
- **supabase-storage** - File storage operations

## Environment Variables

### n8n Skills
Requires n8n-mcp MCP server for workflow management tools. Set these in your environment:
```bash
N8N_API_URL="https://your-n8n-instance.com/api/v1"
N8N_API_KEY="your-api-key"
```

### Supabase Skills (Multi-Account Support)

**Single Account:**
```bash
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_KEY="your-anon-or-service-role-key"
```

**Multiple Accounts:**
```bash
export SUPABASE_ACCOUNTS='[
  {"name":"production","url":"https://prod.supabase.co","key":"prod-key"},
  {"name":"staging","url":"https://staging.supabase.co","key":"staging-key"}
]'
```

Select an account in scripts:
```bash
source skills/supabase/scripts/supabase-api.sh
select_supabase_account "production"
```

## Usage

Skills are automatically available when Claude Code loads this directory. Ask Claude to use a specific skill:

```
Use the supabase-database skill to query my users table
Use the n8n-expression-syntax skill to help me write an expression
```
