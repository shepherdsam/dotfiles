/**
 * Export Session Extension
 *
 * Exports the current pi session as HTML to ~/serv/static/public/ and copies
 * the public URL to the clipboard.
 *
 * Usage:
 *   /exportsession       Export current session
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execSync } from "node:child_process";
import path from "node:path";
import fs from "node:fs";

const PI_BIN = "/opt/homebrew/bin/pi";
const OUTPUT_DIR = path.resolve(process.env.HOME || "~", "serv/static/public");
const BASE_URL = "http://samshem2.tail5d98d.ts.net:3141";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("exportsession", {
    description: "Export current session to HTML and copy public URL to clipboard",
    handler: async (_args, ctx) => {
      if (!ctx.isIdle()) {
        ctx.ui.notify("Waiting for agent to finish...", "info");
        await ctx.waitForIdle();
      }

      const sessionFile = ctx.sessionManager.getSessionFile();
      if (!sessionFile) {
        ctx.ui.notify("No session file found (ephemeral session). Export requires a persisted session.", "error");
        return;
      }

      // Ensure output directory exists
      fs.mkdirSync(OUTPUT_DIR, { recursive: true });

      // Extract UUID from the session filename
      const basename = path.basename(sessionFile).replace(".jsonl", "");
      const parts = basename.split("_");
      const uuid = parts.length > 1 ? parts[parts.length - 1] : basename;

      // Generate output filename with ISO timestamp
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, "0");
      const day = String(now.getDate()).padStart(2, "0");
      const hours = String(now.getHours()).padStart(2, "0");
      const mins = String(now.getMinutes()).padStart(2, "0");
      const secs = String(now.getSeconds()).padStart(2, "0");
      const ms = String(now.getMilliseconds()).padStart(3, "0");
      const ts = `${year}-${month}-${day}T${hours}-${mins}-${secs}-${ms}Z`;
      const filename = `pi-session-${ts}_${uuid}.html`;
      const outputPath = path.join(OUTPUT_DIR, filename);

      try {
        ctx.ui.notify("Exporting session...", "info");

        const result = await pi.exec(PI_BIN, ["--theme", "light", "--export", sessionFile, outputPath], {
          signal: ctx.signal,
          timeout: 30_000,
        });

        if (result.code !== 0) {
          ctx.ui.notify("Export failed (exit code " + result.code + "): " + (result.stderr || result.stdout), "error");
          return;
        }

        // Copy URL to clipboard
        const url = BASE_URL + "/" + filename;
        execSync("pbcopy", { input: url });

        ctx.ui.notify("Session exported: " + url + " (copied to clipboard)", "info");
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        ctx.ui.notify("Export failed: " + msg, "error");
      }
    },
  });
}
