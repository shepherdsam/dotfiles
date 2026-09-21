[[ "$ENV_MODE" == "work" ]] || return

export STATIC_URL="http://dev-tools-service-static-server.tail5d98d.ts.net"

alias keli=/Users/samshe/dev/keli-development-manager/commands.sh

export PATH="$HOME/bin:$PATH"
# Generate commit message with Pi from staged changes
gce() {
  local prompt_file="$HOME/.config/pi/agent/git/bitbucket.org/kellpro/dev-workflow/COMMIT.md"
  local model="litellm/Local Private DeepSeek V4 Flash 0731"

  if [[ ! -f "$prompt_file" ]]; then
    echo "Error: prompt file not found at $prompt_file" >&2
    return 1
  fi

  local msg err
  msg=$(git diff --cached | pi -p --no-tools --no-skills --no-session \
    --thinking off --model "$model" "$(cat "$prompt_file")" 2>/tmp/gce-pi.err)
  local rc=$?
  err=$(cat /tmp/gce-pi.err 2>/dev/null)

  if (( rc != 0 )); then
    echo "Error: pi exited with code $rc" >&2
    [[ -n "$err" ]] && echo "$err" >&2
    return 1
  fi

  if [[ -z "$msg" ]]; then
    echo "pi produced no commit message." >&2
    [[ -n "$err" ]] && echo "$err" >&2
    return 1
  fi

  echo "Generated message:"
  echo "$msg"
  echo
  git commit -e -m "$msg"
}

