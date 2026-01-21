
import { readFileSync, writeFileSync } from "fs";

const p = "mock_config.json";
const cfg = JSON.parse(readFileSync(p, "utf8"));

cfg.bindings = cfg.bindings || [];

const teamBinding = {
  agentId: "team",
  match: {
    provider: "telegram",
    peer: { kind: "dm", id: "8346495442" }
  }
};

const exists = cfg.bindings.find(b => 
    b.agentId === "team" && 
    b.match?.provider === "telegram" && 
    b.match?.peer?.id === "8346495442"
);

if (!exists) {
  cfg.bindings.push(teamBinding);
  writeFileSync(p, JSON.stringify(cfg, null, 2));
  console.log("Updated config bindings.");
} else {
  console.log("Binding already exists.");
}
