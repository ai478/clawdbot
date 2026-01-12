
import { resolveAgentRoute, ResolveAgentRouteInput } from "./src/routing/resolve-route.js";
import { ClawdbotConfig } from "./src/config/config.js";

const mockConfig: ClawdbotConfig = {
  agents: {
    list: [
      { id: "admin" }, // Default because first
      { id: "team" }
    ]
  },
  telegram: { botToken: "fake" },
  bindings: [
    {
      "agentId": "admin",
      "match": {
        "provider": "telegram",
        "peer": { "kind": "dm", "id": "883350587" }
      }
    },
    {
      "agentId": "admin",
      "match": {
        "provider": "telegram",
        "peer": { "kind": "dm", "id": "1383989988" }
      }
    },
    {
      "agentId": "team",
      "match": {
        "provider": "telegram",
        "accountId": "*" 
      }
    }
  ]
};

const adminUser1 = "1383989988";
const adminUser2 = "883350587";
const teamUser = "8346495442";
const randomUser = "999999";

console.log("--- Testing Full Bindings Strategy ---");

const checks = [
    { user: adminUser1, expect: "admin", label: "Admin 1" },
    { user: adminUser2, expect: "admin", label: "Admin 2" },
    { user: teamUser, expect: "team", label: "Team User (via catch-all)" },
    { user: randomUser, expect: "team", label: "Random User (via catch-all)" }
];

for (const check of checks) {
    const route = resolveAgentRoute({
        cfg: mockConfig,
        provider: "telegram",
        peer: { kind: "dm", id: check.user }
    });
    const status = route.agentId === check.expect ? "PASS" : "FAIL";
    console.log(`${status} ${check.label} (${check.user}): Got ${route.agentId}, Expected ${check.expect} (MatchedBy: ${route.matchedBy})`);
}
