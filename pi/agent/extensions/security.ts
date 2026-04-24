import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

const BLOCKED_PATTERNS = [
  "\\.ssh(\\/|$)",
  "\\.aws(\\/|$)",
  "\\.gnupg(\\/|$)",
  "\\.docker(\\/config\\.json|$)",
  "\\.kube(\\/config|$)",
  "\\.password-store(\\/|$)",
  "\\.npmrc$",
  "\\.yarnrc$",
  "\\.env(\\.|$)",
  "\\.key$",
  "\\.pem$",
  "\\.crt$",
  "id_rsa",
  "id_ecdsa",
  "(password|secret|token|private)",
];

const BLOCKED_WRITE_PATTERNS = [
  "\\.git(\\/|$)",
  "node_modules(\\/|$)",
];

const isBlockedWritePath = (path: string): boolean =>
  [...BLOCKED_PATTERNS, ...BLOCKED_WRITE_PATTERNS].some((p) => new RegExp(p, "i").test(path));

const isBlockedReadPath = (path: string): boolean =>
  BLOCKED_PATTERNS.some((p) => new RegExp(p, "i").test(path));

const isRiskyBash = (command: string): boolean =>
  BLOCKED_PATTERNS.some((p) => new RegExp(p.replace(/[\\\\/]/g, "."), "i").test(command)) ||
  command.includes("rm -rf") ||
  command.includes("sudo ") ||
  command.includes("passwd");

export default function security(pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    try {
      if (isToolCallEventType("read", event)) {
        const path = event.input.path;
        if (isBlockedReadPath(path)) {
          return {
            block: true,
            reason: `🚫 SECURITY BLOCK: Sensitive path "${path}" access denied.`,
          };
        }
      } else if (isToolCallEventType("edit", event)) {
        const path = event.input.path;
        if (isBlockedWritePath(path)) {
          return {
            block: true,
            reason: `🚫 SECURITY BLOCK: Edit on sensitive path "${path}" denied.`,
          };
        }
      } else if (isToolCallEventType("write", event)) {
        const path = event.input.path;
        if (isBlockedWritePath(path)) {
          return {
            block: true,
            reason: `🚫 SECURITY BLOCK: Write to sensitive path "${path}" denied.`,
          };
        }
      } else if (isToolCallEventType("bash", event)) {
        const cmd = event.input.command;
        if (isRiskyBash(cmd)) {
          return {
            block: true,
            reason: `🚫 SECURITY BLOCK: Risky bash command "${cmd.substring(0, 50)}..." denied.`,
          };
        }
      }
    } catch (e) {
      // Log but don't block
      console.error("Security check error:", e);
    }
  });

  // Notify on load
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.notify("🛡️ Security extension loaded (blocks .ssh, .env, keys, .git, node_modules, risky bash)", "success");
  });
}
