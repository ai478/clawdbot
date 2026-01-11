
import { readFileSync, writeFileSync } from "fs";
import { homedir } from 'os';
import { join } from 'path';

// Attempt to detect path based on environment
const pathsToCheck = [
    join(homedir(), '.clawdbot', 'clawdbot.json'),
    "/home/node/.clawdbot/clawdbot.json", // Container path
    "/home/clawdis/.clawdbot/clawdbot.json" // Likely host path
];

let configPath = null;
let cfg = null;

for (const p of pathsToCheck) {
    try {
        cfg = JSON.parse(readFileSync(p, "utf8"));
        configPath = p;
        break;
    } catch (e) {
        // Ignore
    }
}

if (!configPath || !cfg) {
    console.error("Could not find clawdbot.json in standard locations.");
    console.error("Checked: ", pathsToCheck.join(", "));
    process.exit(1);
}

console.log(`Found config at ${configPath}`);

// Admin Users
const admins = ["883350587", "1383989988"];

cfg.bindings = cfg.bindings || [];

// 1. Ensure Admin Bindings
for (const adminId of admins) {
    const exists = cfg.bindings.find(b => 
        b.agentId === "admin" && 
        b.match?.provider === "telegram" && 
        b.match?.peer?.id === adminId
    );
    if (!exists) {
        cfg.bindings.push({
            agentId: "admin",
            match: {
                provider: "telegram",
                peer: { kind: "dm", id: adminId }
            }
        });
        console.log(`Added binding for Admin ${adminId}`);
    }
}

// 2. Ensure General Team Binding (Catch-all)
const teamCatchAll = cfg.bindings.find(b => 
    b.agentId === "team" && 
    b.match?.provider === "telegram" && 
    b.match?.accountId === "*"
);

if (!teamCatchAll) {
    cfg.bindings.push({
        agentId: "team",
        match: {
            provider: "telegram",
            accountId: "*"
        }
    });
    console.log("Added catch-all binding for Team agent.");
}

// Remove old "routing" section to avoid confusion (though it is ignored)
if (cfg.routing) {
    delete cfg.routing;
    console.log("Removed deprecated 'routing' section.");
}

writeFileSync(configPath, JSON.stringify(cfg, null, 2));
console.log("Config updated successfully.");
console.log("Please restart your clawdbot container/service for changes to take effect.");
