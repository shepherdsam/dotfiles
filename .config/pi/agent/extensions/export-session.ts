/**
 * Export Session Extension
 *
 * Exports the current pi session as HTML and uploads it via HTTP PUT to a
 * local server, then copies the public URL to the clipboard.
 *
 * Usage:
 *   /exportsession       Export current session
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { createRequire } from "node:module";
import { execSync } from "node:child_process";
import path from "node:path";

const BASE_URL = (process.env.STATIC_URL || "http://localhost:3141").replace(/\/$/, "");

const mainEntry = require.resolve("@earendil-works/pi-coding-agent");
const pkgRoot = path.dirname(path.dirname(mainEntry));
const pkgRequire = createRequire(path.join(pkgRoot, "dist", "index.js"));
const { exportSessionToHtml } = pkgRequire("./core/export-html/index.js");

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
      const tmpPath = path.join("/tmp", filename);

      try {
        ctx.ui.notify("Exporting session...", "info");

        const state = {
          systemPrompt: ctx.getSystemPrompt(),
          tools: pi.getAllTools().map((t) => ({
            name: t.name,
            description: t.description,
            parameters: t.parameters,
          })),
        };

        await exportSessionToHtml(
          ctx.sessionManager as any,
          state as any,
          { outputPath: tmpPath }
        );

        // Upload via HTTP PUT
        const url = `${BASE_URL}/${filename}`;
        const curlCmd = `curl -s -o /dev/null -w "%{http_code}" -X PUT --data-binary @${tmpPath} ${url}`;
        const httpCode = execSync(curlCmd).toString().trim();
        const code = parseInt(httpCode, 10);

        if (code !== 201 && code !== 204) {
          const msg = `Upload failed: HTTP ${httpCode}`;
          console.error(msg);
          ctx.ui.notify(msg, "error");
          return;
        }

        // Copy URL to clipboard
        execSync("pbcopy", { input: url });

        ctx.ui.notify("Session exported: " + url + " (copied to clipboard)", "info");
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        ctx.ui.notify("Export failed: " + msg, "error");
      }
    },
  });
}
