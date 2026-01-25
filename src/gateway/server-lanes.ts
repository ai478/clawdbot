import type { loadConfig } from "../config/config.js";
import {
  resolveAgentMaxConcurrent,
  resolveAgentSessionConcurrency,
  resolveSubagentMaxConcurrent,
} from "../config/agent-limits.js";
import { setCommandLaneConcurrency } from "../process/command-queue.js";
import { CommandLane } from "../process/lanes.js";

export function applyGatewayLaneConcurrency(cfg: ReturnType<typeof loadConfig>) {
  // Special lanes (unchanged)
  setCommandLaneConcurrency(CommandLane.Cron, cfg.cron?.maxConcurrentRuns ?? 1);
  setCommandLaneConcurrency(CommandLane.Subagent, resolveSubagentMaxConcurrent(cfg));

  // Legacy main lane (keep for backward compatibility)
  setCommandLaneConcurrency(CommandLane.Main, resolveAgentMaxConcurrent(cfg));

  // Per-agent lanes (NEW)
  const agentConfigs = cfg?.agents?.list ?? [];
  for (const agent of agentConfigs) {
    const agentLane = `agent:${agent.id}`;
    const concurrency = resolveAgentSessionConcurrency(cfg, agent.id);
    setCommandLaneConcurrency(agentLane, concurrency);
  }
}
