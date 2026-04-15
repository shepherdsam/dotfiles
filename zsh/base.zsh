# zsh
alias editzsh="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias reloadzsh="source ~/.zshrc"

# goose
eval "$(goose completion zsh)"
export GOOSE_SANDBOX=true

# nvim
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
 
alias nv="nvim"
alias editconfig="nvim ~/.config"

alias pullzshconfig="cp -R ./zsh ~/.config/"
alias pushzshconfig="cp -R ~/.config/zsh ."
