/**
 * Keys to scrub from the agent's shell environment to prevent accidental disclosure.
 * These are also propagated from the host to sandboxes if present.
 */
export const SENSITIVE_KEYS = [
  "TELEGRAM_BOT_TOKEN",
  "CLAWDBOT_GATEWAY_TOKEN",
  "GITHUB_TOKEN",
  "OPENAI_API_KEY",
  "ANTHROPIC_API_KEY",
  "GEMINI_API_KEY",
  "ELEVENLABS_API_KEY",
  "BRAVE_API_KEY",
  "GOOGLE_PLACES_API_KEY",
  "LINEAR_API_KEY",
  "CLAUDE_AI_SESSION_KEY",
  "CLAUDE_WEB_SESSION_KEY",
  "CLAUDE_WEB_COOKIE",
  "GITLAB_TOKEN",
  "MINIMAX_API_KEY",
  "N8N_API_URL",
  "N8N_API_KEY",
  // Supabase - single account mode
  "SUPABASE_URL",
  "SUPABASE_SERVICE_ROLE_KEY",
  "SUPABASE_ANON_KEY",
  // Supabase - multi-account mode
  "SUPABASE_ACCOUNTS",
];
