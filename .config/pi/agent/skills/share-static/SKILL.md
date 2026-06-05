---
name: share-static
description: Upload a file to the static file server via PUT and copy the public URL to the clipboard. Use when the user says "share", "share this", "copy to static", or asks to make a file or output accessible via URL.
---

# Share Static

Uploads files to a static file server via `curl PUT` and copies the resulting URL to clipboard.

## Static URL

`http://dev-tools-service-static-server.tail5d98d.ts.net` (override via `STATIC_URL` env var). The same URL is used for both upload and the clipboard link.

## Upload helper

A shared `upload_and_clipboard` function handles the curl call and response checking:

```bash
upload_and_clipboard() {
  local file_path="$1"
  local filename="$2"
  local base_url="${STATIC_URL:-http://dev-tools-service-static-server.tail5d98d.ts.net}"
  local url="$base_url/$filename"

  local http_code
  http_code=$(curl -s -o /dev/null -w "%{http_code}" -X PUT --data-binary @"$file_path" "$url")

  if [ "$http_code" = "201" ] || [ "$http_code" = "204" ]; then
    echo -n "$url" | pbcopy
    echo "$url"
  else
    echo "Upload failed: HTTP $http_code" >&2
  fi
}
```

## File sharing

Given a file path, generate a timestamped filename and upload it:

```bash
TIMESTAMP=$(date -u +"%Y-%m-%dT%H-%M-%S-%3NZ")
FILENAME="share-${TIMESTAMP}_$(basename "$FILE")"
upload_and_clipboard "$FILE" "$FILENAME"
```

## Generated content sharing

When content is generated (code, markdown, data), write it to a temp file first, then upload:

```bash
TIMESTAMP=$(date -u +"%Y-%m-%dT%H-%M-%S-%3NZ")
TEMPFILE="/tmp/share-${TIMESTAMP}_$NAME"
cat > "$TEMPFILE" << 'EOF'
...content...
EOF
upload_and_clipboard "$TEMPFILE" "$(basename "$TEMPFILE")"
```

Generate a descriptive filename based on the content type (e.g., `output.json`, `diagram.png`, `summary.md`).

## Determining the filename

- For file sharing: use the original filename, prefixed with `share-<timestamp>_`.
- For generated content: derive from content type. Use `NAME` as provided or infer from context (e.g., `code.py`, `plan.md`, `config.yaml`).
