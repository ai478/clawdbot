import { describe, expect, it } from "vitest";
import type { AgentMessage } from "@mariozechner/pi-agent-core";
import { limitHistoryTokens, countMessageTokensHeuristic } from "./pi-embedded-runner.js";

describe("limitHistoryTokens", () => {
    const makeMessages = (lengths: number[]): AgentMessage[] =>
        lengths.map((len, i) => ({
            role: i % 2 === 0 ? "user" : "assistant",
            content: [{ type: "text", text: "a".repeat(len * 4) }], // 4 chars per token heuristic
            timestamp: Date.now(),
        } as any));

    it("returns all messages when within limit", () => {
        const messages = makeMessages([10, 10, 10]); // ~30 tokens
        expect(limitHistoryTokens(messages, 50).length).toBe(3);
    });

    it("truncates old messages to fit limit", () => {
        const messages = makeMessages([20, 20, 20]); // ~60 tokens
        const limited = limitHistoryTokens(messages, 50);
        expect(limited.length).toBe(2);
        expect((limited[0] as any).content).toEqual([{ type: "text", text: "a".repeat(20 * 4) }]);
    });

    it("returns only the last message if it barely fits", () => {
        const messages = makeMessages([20, 20, 20]);
        const limited = limitHistoryTokens(messages, 25);
        expect(limited.length).toBe(1);
    });

    it("returns empty if even the last message is too big", () => {
        const messages = makeMessages([100]);
        const limited = limitHistoryTokens(messages, 50);
        expect(limited.length).toBe(0);
    });

    it("handles empty messages", () => {
        expect(limitHistoryTokens([], 100)).toEqual([]);
    });
});

describe("countMessageTokensHeuristic", () => {
    it("counts text content", () => {
        const msg: AgentMessage = { role: "user", content: "abcd efg", timestamp: Date.now() } as any; // 8 chars -> 2 tokens
        expect(countMessageTokensHeuristic(msg)).toBe(2);
    });

    it("counts array text parts", () => {
        const msg: AgentMessage = {
            role: "user",
            content: [{ type: "text", text: "abcd" }, { type: "text", text: "efgh" }],
            timestamp: Date.now()
        } as any;
        expect(countMessageTokensHeuristic(msg)).toBe(2);
    });

    it("counts tool calls and results", () => {
        const msg: AgentMessage = {
            role: "assistant",
            content: [
                { type: "toolCall", id: "1", name: "exec", arguments: { cmd: "ls" } }, // {"cmd":"ls"} is 12 chars -> 3 tokens
                { type: "toolResult", toolCallId: "1", content: "file1" } // "file1" is 5 chars -> 2 tokens
            ],
            timestamp: Date.now()
        } as any;
        // 12 + 5 = 17 chars -> Math.ceil(17/4) = 5 tokens
        expect(countMessageTokensHeuristic(msg)).toBe(5);
    });
});
