# Shared helpers for tmux-save / tmux-restore / tmux-up
# Sourced by those scripts; not meant to be run directly.

SNAPSHOT_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux/snapshots"
SNAPSHOT_VERSION=1
AUTO_SAVE_SECONDS=900  # 15 minutes

ensure_snapshot_dir() {
  mkdir -p "$SNAPSHOT_DIR"
}

snapshot_path() {
  local name="${1:-last}"
  # basename guards against path traversal
  name="$(basename -- "$name")"
  printf '%s/%s\n' "$SNAPSHOT_DIR" "$name"
}

session_exists() {
  tmux has-session -t "$1" 2>/dev/null
}

any_sessions() {
  tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -q .
}

resolve_path() {
  # Prefer existing path; else $HOME (caller may warn)
  local p="$1"
  if [[ -d "$p" ]]; then
    printf '%s\n' "$p"
    return 0
  fi
  printf '%s\n' "$HOME"
  return 1
}

attach_preferred() {
  if session_exists main; then
    tmux attach -t main
  else
    tmux attach
  fi
}
