export PATH="$HOME/bin:$PATH"
export PATH=/Applications/Postgres.app/Contents/Versions/16/bin:$PATH
export EDITOR=nvim
export HOMEBREW_NO_ENV_HINTS=true

. ~/.secrets

alias opal="ssh bhoggard@opal12.opalstack.com"
alias code=code-insiders
alias cm=chezmoi

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(ssh-agent -s)"
eval "$(/opt/homebrew/bin/mise activate zsh)"

