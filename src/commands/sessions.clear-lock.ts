import fs from "node:fs/promises";
import path from "node:path";
import { loadConfig } from "../config/config.js";
import { resolveStorePath } from "../config/sessions.js";
import { info, success, warn } from "../globals.js";
import type { RuntimeEnv } from "../runtime.js";

export async function clearSessionsLockCommand(
  opts: { store?: string },
  runtime: RuntimeEnv,
) {
  const cfg = loadConfig();
  const storePath = resolveStorePath(opts.store ?? cfg.session?.store);
  const sessionDir = path.dirname(storePath);

  runtime.log(info(`Scanning for lock files in: ${sessionDir}`));

  try {
    const files = await fs.readdir(sessionDir);
    const locks = files.filter((f) => f.endsWith(".lock"));

    if (locks.length === 0) {
      runtime.log("No lock files found.");
      return;
    }

    runtime.log(warn(`Found ${locks.length} lock file(s). Clearing...`));

    for (const lock of locks) {
      const lockFullPath = path.join(sessionDir, lock);
      await fs.rm(lockFullPath, { force: true });
      runtime.log(success(`Removed: ${lock}`));
    }

    runtime.log(success("All session locks cleared successfully."));
  } catch (err) {
    runtime.error(`Failed to clear session locks: ${String(err)}`);
    runtime.exit(1);
  }
}
