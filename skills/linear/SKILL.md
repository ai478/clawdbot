---
name: linear
description: "Linear API for creating issues, managing projects, and tracking work. Use for ticket creation, status updates, and commenting."
homepage: https://developers.linear.app
metadata:
  {
    "clawdbot":
      {
        "emoji": "📐",
        "requires": { "bins": ["curl"], "env": ["LINEAR_API_KEY"] },
        "primaryEnv": "LINEAR_API_KEY",
      },
  }
---

# Linear

Integrate with Linear to manage issues, projects, and cycles.

## Setup

1. Create a Personal Access Token in Linear: https://linear.app/settings/api
2. Set the `LINEAR_API_KEY` environment variable.

## Features

- Create and update issues
- Manage projects and teams
- Track progress of cycles and initiatives
- Add comments and attachments
