# OpenClaw - Agent Development Guide

> **For AI Coding Agents**: This document contains essential information about the OpenClaw project architecture, development workflows, and coding conventions. Read this first before making any changes.

## Project Overview

**OpenClaw** is a personal AI assistant platform that you run on your own devices. It provides a unified gateway for AI agents to interact with users across multiple messaging channels (WhatsApp, Telegram, Slack, Discord, Signal, iMessage, Microsoft Teams, Matrix, Zalo, WebChat, and more).

The project consists of:
- **Gateway**: A WebSocket-based control plane that manages sessions, channels, and AI agents
- **CLI**: Command-line interface for configuration, management, and interaction
- **Pi Agent Runtime**: RPC-based AI agent execution with tool streaming
- **Companion Apps**: macOS menu bar app, iOS/Android nodes for device-local actions
- **Extensions**: Plugin system for additional channels and providers

Repository: https://github.com/openclaw/openclaw  
Documentation: https://docs.openclaw.ai  
Discord: https://discord.gg/clawd

## Technology Stack

### Core Runtime
- **Language**: TypeScript (ESM modules, strict mode)
- **Runtime**: Node.js 22+ (required)
- **Package Manager**: pnpm 10.23.0 (primary), Bun also supported
- **Build Tool**: TypeScript compiler (tsc)

### Linting & Formatting
- **Linter**: Oxlint with type-aware checking
- **Formatter**: Oxfmt
- **Configuration**: `.oxlintrc.json`, `.oxfmtrc.jsonc`

### Testing
- **Framework**: Vitest with V8 coverage
- **Coverage Thresholds**: 70% lines/functions/statements, 55% branches
- **Test Types**: Unit tests (`*.test.ts`), E2E tests (`*.e2e.test.ts`), Live tests (`*.live.test.ts`)

### Mobile Apps
- **macOS**: Swift (SwiftUI with Observation framework), SwiftLint, SwiftFormat
- **iOS**: Swift (XcodeGen for project generation)
- **Android**: Kotlin (Gradle build system)

### Infrastructure
- **Docker**: Multi-stage builds with Node.js 22-bookworm base
- **CI/CD**: GitHub Actions (Blacksmith runners for Linux, macOS for Apple platforms)
- **Documentation**: Mintlify (docs.openclaw.ai)

## Project Structure

```
openclaw/
├── src/                          # Main TypeScript source code
│   ├── cli/                      # CLI wiring and utilities
│   ├── commands/                 # CLI commands (agent, gateway, config, etc.)
│   ├── gateway/                  # WebSocket gateway server
│   ├── channels/                 # Channel abstractions
│   ├── telegram/                 # Telegram channel (grammY)
│   ├── discord/                  # Discord channel (discord.js)
│   ├── slack/                    # Slack channel (Bolt)
│   ├── signal/                   # Signal channel (signal-cli)
│   ├── imessage/                 # iMessage channel (macOS only)
│   ├── web/                      # WhatsApp Web (Baileys)
│   ├── routing/                  # Message routing logic
│   ├── agents/                   # Pi agent runtime integration
│   ├── sessions/                 # Session management
│   ├── plugins/                  # Plugin system
│   ├── plugin-sdk/               # Plugin SDK for extensions
│   ├── browser/                  # Browser automation (Playwright)
│   ├── canvas-host/              # Canvas/A2UI host
│   ├── media/                    # Media processing pipeline
│   ├── memory/                   # Vector memory (sqlite-vec)
│   ├── infra/                    # Infrastructure utilities
│   ├── utils.ts                  # Shared utilities
│   └── *.test.ts                 # Colocated tests
├── apps/                         # Companion applications
│   ├── macos/                    # macOS menu bar app (Swift)
│   ├── ios/                      # iOS node app (Swift)
│   ├── android/                  # Android node app (Kotlin)
│   └── shared/                   # Shared code for apps
├── extensions/                   # Plugin extensions
│   ├── msteams/                  # Microsoft Teams
│   ├── matrix/                   # Matrix protocol
│   ├── zalo/                     # Zalo
│   └── ...                       # Other channel extensions
├── packages/                     # Internal packages
│   ├── clawdbot/                 # Clawdbot package
│   └── moltbot/                  # Moltbot package
├── ui/                           # Web UI (Control UI, WebChat)
├── docs/                         # Documentation (Mintlify)
├── scripts/                      # Build and utility scripts
├── skills/                       # Bundled skills
├── dist/                         # Compiled output (gitignored)
└── test/                         # Test setup and helpers
```

## Build & Development Commands

### Essential Commands

```bash
# Install dependencies
pnpm install

# Build the project (compiles TypeScript to dist/)
pnpm build

# Run in development mode (auto-reload via tsx)
pnpm dev
pnpm openclaw ...               # Run CLI via Bun/Node with tsx

# Type check only (no emit)
pnpm tsgo

# Lint and format
pnpm check                      # Run all checks (tsgo + lint + format)
pnpm lint                       # Oxlint with type-aware checking
pnpm lint:fix                   # Auto-fix lint issues
pnpm format                     # Check formatting
pnpm format:fix                 # Auto-fix formatting

# Testing
pnpm test                       # Run unit/integration tests
pnpm test:coverage              # Run with coverage report
pnpm test:e2e                   # Run E2E tests
pnpm test:live                  # Run live tests (requires API keys)
pnpm test:watch                 # Watch mode for tests

# Gateway development
pnpm gateway:watch              # Watch mode for gateway
pnpm gateway:dev                # Dev mode with channels skipped

# UI
pnpm ui:build                   # Build web UI
pnpm ui:dev                     # Dev mode for UI

# Mobile apps
pnpm mac:package                # Package macOS app
pnpm ios:build                  # Build iOS app
pnpm ios:run                    # Run iOS app on simulator
pnpm android:assemble           # Build Android app
pnpm android:run                # Install and run Android app

# Documentation
pnpm docs:dev                   # Run docs locally
pnpm docs:build                 # Build docs (check broken links)
```

### Full Development Setup

```bash
# 1. Clone and install
git clone https://github.com/openclaw/openclaw.git
cd openclaw
pnpm install

# 2. Build UI and project
pnpm ui:build
pnpm build

# 3. Run onboarding wizard
pnpm openclaw onboard --install-daemon

# 4. Start gateway in dev mode
pnpm gateway:watch
```

## Code Style Guidelines

### TypeScript Conventions

1. **Use strict typing** - Avoid `any`; use `unknown` with type guards when needed
2. **ESM modules only** - No CommonJS; use `.js` extensions in imports
3. **File size guideline** - Keep files under ~500-700 LOC; split when needed
4. **Comments** - Add brief comments for tricky or non-obvious logic
5. **Naming**:
   - `OpenClaw` - Product/app/docs headings
   - `openclaw` - CLI command, package/binary, paths, config keys

### Code Patterns

```typescript
// Prefer explicit types over inference for function returns
function loadConfig(path: string): Config {
  // ...
}

// Use dependency injection via createDefaultDeps
export function createDefaultDeps(): Dependencies {
  return {
    // ...
  };
}

// Colocate tests: foo.ts -> foo.test.ts
// Use Vitest with describe/it/expect
```

### Swift (iOS/macOS)

- Use the `Observation` framework (`@Observable`, `@Bindable`)
- Avoid `ObservableObject`/`@StateObject` unless required for compatibility
- Follow SwiftLint and SwiftFormat rules

### Tool Schema Guardrails

When defining tool schemas using TypeBox:

- **Avoid** `Type.Union` in tool input schemas (no `anyOf`/`oneOf`/`allOf`)
- Use `stringEnum`/`optionalStringEnum` for string lists
- Use `Type.Optional(...)` instead of `... | null`
- Keep top-level tool schema as `type: "object"` with `properties`
- Avoid raw `format` property names (reserved keyword in some validators)

## Testing Strategy

### Test Organization

| Suite | Pattern | Command | Purpose |
|-------|---------|---------|---------|
| Unit/Integration | `*.test.ts` | `pnpm test` | Fast, deterministic tests without external APIs |
| E2E | `*.e2e.test.ts` | `pnpm test:e2e` | Gateway networking, WebSocket, multi-instance |
| Live | `*.live.test.ts` | `pnpm test:live` | Real providers/models (requires API keys) |

### Live Testing

Live tests require real API keys and are not CI-stable by design:

```bash
# Run all live tests
OPENCLAW_LIVE_TEST=1 pnpm test:live

# Test specific models
OPENCLAW_LIVE_GATEWAY_MODELS="anthropic/claude-opus-4-5,openai/gpt-5.2" pnpm test:live

# Docker-based live tests
pnpm test:docker:live-models
pnpm test:docker:live-gateway
pnpm test:docker:onboard
```

### Coverage Requirements

- **Thresholds**: 70% lines/functions/statements, 55% branches
- Run `pnpm test:coverage` before pushing significant changes
- Some files are intentionally excluded from coverage (see `vitest.config.ts`)

## Security Considerations

### Configuration & Secrets

1. **Never commit real secrets** - Use `.env` files (gitignored)
2. **Use profile store** - `~/.openclaw/credentials/` for auth tokens
3. **detect-secrets** - Pre-commit hook scans for secrets
4. **Environment variables** - See `.env.example` for required variables

### DM Security Defaults

OpenClaw treats inbound DMs as untrusted by default:

- **Pairing mode** (`dmPolicy="pairing"`): Unknown senders receive a pairing code
- **Approval required**: `openclaw pairing approve <channel> <code>`
- **Explicit opt-in** required for open DMs (`dmPolicy="open"` + `"*"` in allowlist)

### Sandbox Mode

- **Default**: Tools run on host for `main` session
- **Non-main sessions**: Can run in Docker sandboxes (`agents.defaults.sandbox.mode: "non-main"`)
- **Sandbox defaults**: Allowlist `bash`, `process`, `read`, `write`, `edit`; denylist `browser`, `canvas`, `nodes`, `cron`

## Deployment & Release

### Release Channels

- **stable**: Tagged releases (`vYYYY.M.D`), npm dist-tag `latest`
- **beta**: Prerelease tags (`vYYYY.M.D-beta.N`), npm dist-tag `beta`
- **dev**: Moving head on `main`, npm dist-tag `dev`

### Docker Deployment

```bash
# Build image
docker build -t openclaw:local .

# Run with docker-compose
docker-compose up -d openclaw-gateway
```

### Version Locations

When updating versions, update all these files:
- `package.json` (CLI version)
- `apps/android/app/build.gradle.kts` (versionName/versionCode)
- `apps/ios/Sources/Info.plist` + `apps/ios/Tests/Info.plist`
- `apps/macos/Sources/OpenClaw/Resources/Info.plist`
- `docs/install/updating.md`

## Working with Extensions

Extensions live in `extensions/*` and are pnpm workspace packages:

1. Keep plugin-only deps in the extension's `package.json`
2. Avoid `workspace:*` in `dependencies` (npm install breaks)
3. Put `openclaw` in `devDependencies` or `peerDependencies`
4. Runtime resolves `openclaw/plugin-sdk` via jiti alias

## CI/CD Pipeline

GitHub Actions workflow (`.github/workflows/ci.yml`):

1. **install-check**: Verifies dependencies install correctly
2. **checks**: TypeScript, lint, tests (Node + Bun), protocol check, format
3. **checks-windows**: Windows-specific build and test
4. **checks-macos**: macOS-specific tests
5. **macos-app**: Swift build, lint, test
6. **android**: Gradle build and unit tests
7. **secrets**: detect-secrets scanning

## Troubleshooting

### Common Commands

```bash
# Check configuration
openclaw doctor

# Reset configuration
openclaw reset

# Check gateway status
openclaw gateway status --probe

# View logs (macOS)
./scripts/clawlog.sh
```

### Multi-Agent Safety

When working alongside other agents:

- Do **not** create/apply/drop `git stash` entries unless requested
- Do **not** switch branches unless explicitly requested
- Do **not** create/remove/modify `git worktree` checkouts
- Focus on your changes only; commit scoped changes
- When pushing: `git pull --rebase` to integrate latest changes

## Reference Links

- **Docs**: https://docs.openclaw.ai
- **Architecture**: https://docs.openclaw.ai/concepts/architecture
- **Configuration**: https://docs.openclaw.ai/gateway/configuration
- **Security**: https://docs.openclaw.ai/gateway/security
- **Testing**: https://docs.openclaw.ai/concepts/testing (see `docs/testing.md`)

## Maintainer Notes

- **Benevolent Dictator**: Peter Steinberger (@steipete)
- **Discord + Slack**: Shadow (@thewilloftheshadow)
- **Telegram/API/Nix**: Jos (@joshp123)
- **JS Infra**: Christoph Nakazawa (@cpojer)

---

*Last updated: Generated from project analysis. For the latest information, check the repository and documentation.*
