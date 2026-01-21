import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const OXFMT_EXTENSIONS = new Set([
  ".cjs",
  ".js",
  ".json",
  ".jsonc",
  ".jsx",
  ".mjs",
  ".ts",
  ".tsx",
]);

function getRepoRoot() {
  const here = path.dirname(fileURLToPath(import.meta.url));
  return path.resolve(here, "..");
}

function runGitCommand(args, options = {}) {
  return spawnSync("git", args, {
    cwd: options.cwd,
    encoding: "utf-8",
    stdio: options.stdio ?? "pipe",
  });
}

function splitNullDelimited(value) {
  if (!value) return [];
  const text = String(value);
  return text.split("\0").filter(Boolean);
}

function normalizeGitPath(filePath) {
  return filePath.replace(/\\/g, "/");
}

function filterOxfmtTargets(paths) {
  return paths
    .map(normalizeGitPath)
    .filter((filePath) =>
      (filePath.startsWith("src/") || filePath.startsWith("test/")) &&
      OXFMT_EXTENSIONS.has(path.posix.extname(filePath)),
    );
}

function findPartiallyStagedFiles(stagedFiles, unstagedFiles) {
  const unstaged = new Set(unstagedFiles.map(normalizeGitPath));
  return stagedFiles.filter((filePath) => unstaged.has(normalizeGitPath(filePath)));
}

function filterOutPartialTargets(targets, partialTargets) {
  if (partialTargets.length === 0) return targets;
  const partial = new Set(partialTargets.map(normalizeGitPath));
  return targets.filter((filePath) => !partial.has(normalizeGitPath(filePath)));
}

function resolveOxfmtCommand(repoRoot) {
  const binName = process.platform === "win32" ? "oxfmt.cmd" : "oxfmt";
  const local = path.join(repoRoot, "node_modules", ".bin", binName);
  if (fs.existsSync(local)) {
    return { command: local, args: [] };
  }

  const result = spawnSync("oxfmt", ["--version"], { stdio: "ignore" });
  if (result.status === 0) {
    return { command: "oxfmt", args: [] };
  }

  return null;
}

function getGitPaths(args, repoRoot) {
  const result = runGitCommand(args, { cwd: repoRoot });
  if (result.status !== 0) return [];
  return splitNullDelimited(result.stdout ?? "");
}

function formatFiles(repoRoot, oxfmt, files) {
  console.log(`[pre-commit] Running ${oxfmt.command} on ${files.length} file(s)...`);
  const result = spawnSync(oxfmt.command, ["--write", ...oxfmt.args, ...files], {
    cwd: repoRoot,
    stdio: "inherit",
    shell: true, // Required for .cmd on Windows
  });
  if (result.error) {
    console.error(`[pre-commit] spawn error: ${result.error.message}`);
    return false;
  }
  if (result.status !== 0) {
    // If status is null but no error, it might be a signal
    const code = result.status === null ? "signal " + result.signal : result.status;
    console.error(`[pre-commit] formatting failed with code ${code}`);
    return false;
  }
  return true;
}

function stageFiles(repoRoot, files) {
  if (files.length === 0) return true;
  console.log(`[pre-commit] Re-staging ${files.length} file(s)...`);
  const result = runGitCommand(["add", "--", ...files], { cwd: repoRoot, stdio: "inherit" });
  if (result.status !== 0) {
    console.error(`[pre-commit] git add failed with code ${result.status}`);
    return false;
  }
  return true;
}

function main() {
  try {
    const repoRoot = getRepoRoot();
    const staged = getGitPaths([
      "diff",
      "--cached",
      "--name-only",
      "-z",
      "--diff-filter=ACMR",
    ], repoRoot);

    const targets = filterOxfmtTargets(staged);
    if (targets.length === 0) {
      // console.log("[pre-commit] No staged files to format.");
      return;
    }

    const unstaged = getGitPaths(["diff", "--name-only", "-z"], repoRoot);
    const partial = findPartiallyStagedFiles(targets, unstaged);
    if (partial.length > 0) {
      process.stderr.write("[pre-commit] Skipping partially staged files:\n");
      for (const filePath of partial) {
        process.stderr.write(`- ${filePath}\n`);
      }
      process.stderr.write("Stage full files to format them automatically.\n");
    }

    const filteredTargets = filterOutPartialTargets(targets, partial);
    if (filteredTargets.length === 0) return;

    const oxfmt = resolveOxfmtCommand(repoRoot);
    if (!oxfmt) {
      process.stderr.write("[pre-commit] oxfmt not found; skipping format.\n");
      return;
    }

    if (!formatFiles(repoRoot, oxfmt, filteredTargets)) {
      console.error("[pre-commit] Formatting failed. Fix the errors above or use 'git commit --no-verify' to bypass.");
      process.exitCode = 1;
      return;
    }

    if (!stageFiles(repoRoot, filteredTargets)) {
      console.error("[pre-commit] Staging failed. Please stage the changes manually.");
      process.exitCode = 1;
    }
  } catch (error) {
    console.error("[pre-commit] Unexpected error:", error);
    console.error("[pre-commit] You can bypass this hook with 'git commit --no-verify'");
    process.exitCode = 1;
  }
}

export {
  filterOxfmtTargets,
  filterOutPartialTargets,
  findPartiallyStagedFiles,
  getRepoRoot,
  normalizeGitPath,
  resolveOxfmtCommand,
  splitNullDelimited,
};

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main();
}
