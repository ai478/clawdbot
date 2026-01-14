import { describe, expect, it, vi } from "vitest";
import { resolveSandboxDockerConfig } from "./sandbox/config.js";

describe("resolveSandboxDockerConfig", () => {
  it("propagates sensitive keys from process.env", () => {
    vi.stubEnv("LINEAR_API_KEY", "test-linear-key");
    vi.stubEnv("BRAVE_API_KEY", "test-brave-key");
    
    // Key that should NOT be propagated (not in SENSITIVE_KEYS)
    vi.stubEnv("SOME_OTHER_KEY", "secret");

    const globalDocker = {
      image: "test-image",
    };

    const config = resolveSandboxDockerConfig({
      scope: "agent",
      globalDocker,
    });

    expect(config.env).toBeDefined();
    expect(config.env?.LINEAR_API_KEY).toBe("test-linear-key");
    expect(config.env?.BRAVE_API_KEY).toBe("test-brave-key");
    expect(config.env?.SOME_OTHER_KEY).toBeUndefined();

    vi.unstubAllEnvs();
  });

  it("supports 'volumes' alias for binds", () => {
    const globalDocker = {
      volumes: ["/host/path:/container/path:ro"]
    } as any;

    const agentDocker = {
      binds: ["/agent/path:/container/path:rw"]
    };

    const config = resolveSandboxDockerConfig({
      scope: "agent",
      globalDocker,
      agentDocker,
    });

    expect(config.binds).toContain("/host/path:/container/path:ro");
    expect(config.binds).toContain("/agent/path:/container/path:rw");
  });

  it("prioritizes provided env over process.env propagation", () => {
    vi.stubEnv("LINEAR_API_KEY", "test-linear-key");
    
    const agentDocker = {
      env: {
        LINEAR_API_KEY: "override-key"
      }
    };

    const config = resolveSandboxDockerConfig({
      scope: "agent",
      agentDocker,
    });

    expect(config.env?.LINEAR_API_KEY).toBe("override-key");

    vi.unstubAllEnvs();
  });
});
