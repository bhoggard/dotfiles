export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/postgresql@12/bin:$PATH"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="$HOME/bin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

. ~/.secrets
alias be="bundle exec"
alias rub="git diff --name-only | xargs bundle exec rubocop -a"
alias rubs="git diff --staged --name-only | xargs bundle exec rubocop -a"

alias gpc="hokusai production run --tty 'rails c production'"
alias gsc="hokusai staging run --tty 'rails c staging'"

alias pc="hokusai production run --tty 'bundle exec rails c'"
alias sc="hokusai staging run --tty 'bundle exec rails c'"

export HOKUSAI_ALWAYS_VERBOSE=True

export EDITOR=vim

alias tf=terraform

alias netshoot='kubectl run tmp-shell-$(whoami) --restart=Never --rm -i --tty --image nicolaka/netshoot -- /bin/bash'

alias 'k8s'='aws-iam-authenticator token -i $(kubectl config get-clusters | grep kubernetes-staging) -r arn:aws:iam::585031190124:role/KubernetesDev | jq -r .status.token | pbcopy'
alias 'k8p'='aws-iam-authenticator token -i $(kubectl config get-clusters | grep kubernetes-production) -r arn:aws:iam::585031190124:role/KubernetesDev | jq -r .status.token | pbcopy'

alias hp='hokusai production'
alias hs='hokusai staging'

alias grav='cd ~/code/artsy/gravity'
