[[ "$ENV_MODE" == "work" ]] || return

export STATIC_URL="http://dev-tools-service-static-server.tail5d98d.ts.net"

alias keli=/Users/samshe/dev/keli-development-manager/commands.sh

export PATH="$HOME/bin:$PATH"

# Generate commit message with Pi from staged changes
gce() {
  #!/usr/bin/env bash

  # Generate commit message with Pi from staged changes
  prompt_file="$HOME/.config/pi/agent/git/bitbucket.org/kellpro/dev-workflow/COMMIT.md"

  if [[ ! -f "$prompt_file" ]]; then
    echo "Error: prompt file not found at $prompt_file" >&2
    return 1
  fi

  msg=$(git diff --cached | pi -p --no-tools --no-extensions --no-skills --model "fireworks/deepseek-v4-flash-0731" "$(cat "$prompt_file")")

  if [[ -z "$msg" ]]; then
    echo "No commit message generated or no staged changes."
    return 1
  fi

  echo "Generated message:"
  echo "$msg"
  echo

  # Open editor with the generated message pre-filled
  git commit -e -m "$msg"
}

