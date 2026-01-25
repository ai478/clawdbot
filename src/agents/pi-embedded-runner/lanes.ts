import { CommandLane } from "../../process/lanes.js";
import { normalizeAgentId } from "../../routing/session-key.js";

export function resolveSessionLane(key: string) {
  const cleaned = key.trim() || CommandLane.Main;
  return cleaned.startsWith("session:") ? cleaned : `session:${cleaned}`;
}

export function resolveAgentLane(agentId: string): string {
  const normalized = normalizeAgentId(agentId);
  return `agent:${normalized}`;
}

export function resolveGlobalLane(lane?: string, agentId?: string): string {
  const cleaned = lane?.trim();

  // Explicit lane override
  if (cleaned) return cleaned;

  // Per-agent lane (new default)
  if (agentId) return resolveAgentLane(agentId);

  // Fallback to main lane
  return CommandLane.Main;
}

export function resolveEmbeddedSessionLane(key: string) {
  return resolveSessionLane(key);
}
