# zsh
alias editzsh="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias reloadzsh="source ~/.zshrc"

alias editconfig="nvim ~/.config"

# vim mode
# bindkey -v # DOT NOT WORK - instead add vi-mode to list of plugins in `~/.zshrc`

# nvim
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export VISUAL="vim"
  export EDITOR="vim"
else
  export VISUAL="nvim"
  export EDITOR="nvim"
fi
 
alias nv="nvim"

# tmux helpers
alias tls='tmux ls'
alias ta='tmux attach -t'
alias tn='tmux new -s'          # e.g. tn work
alias tk='tmux kill-session -t' # e.g. tk old-session
alias tkillall='tmux kill-server' # nuclear option

# Auto tmux: attach if sessions exist, else restore snapshot then attach
# (see ~/bin/tmux-up, ~/bin/tmux-save, ~/bin/tmux-restore)
if [[ -z "$TMUX" ]] && [[ -o interactive ]]; then
  if command -v tmux-up >/dev/null 2>&1; then
    tmux-up
  elif [[ -x "$HOME/bin/tmux-up" ]]; then
    "$HOME/bin/tmux-up"
  fi
fi

# Theme switcher convenience aliases (provided by ~/bin/theme after install)
alias dark='theme dark'
alias light='theme light'

