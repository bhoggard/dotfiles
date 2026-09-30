export PATH="$HOME/.config/emacs/bin:$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="/usr/local/mysql/bin:opt/homebrew/opt/postgresql@18/bin:$PATH"

# export LDFLAGS="-L/opt/homebrew/opt/postgresql@18/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/postgresql@18/include"

export EDITOR=nvim
export HOMEBREW_NO_ENV_HINTS=true

. ~/.secrets

alias opal="ssh bhoggard@opal12.opalstack.com"
alias cm=chezmoi
alias j="bundle exec jekyll serve -I"

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(ssh-agent -s)"

# Set XDG_CONFIG_HOME for clean management of configuration files
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"

alias c="clojure -M:repl/rebel"
alias k=kubectl
alias jk="bundle exec jekyll serve --livereload"
alias emacs="emacs -nw"
alias cl="claude --dangerously-skip-permissions"

eval "$(/Users/barry/.local/bin/mise activate zsh)"

