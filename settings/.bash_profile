# Alias's to modified commands

alias ls='ls --color=tty'
alias ll='ls -l'
alias rm='rm -iv'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color'

#alias ps='ps auxf'
#alias less='less -R'
#alias multitail='multitail --no-repeat -c'

alias vi='vim'
#alias vis='vim "+set si"'

# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}
export -f parse_git_branch
export PS1="\u@\h\w\[\e[0;33;49m\]\$(parse_git_branch)\[\e[0;0m\]\$ "

_old_exp_sm() {
  ## Expand S:M
  if echo $@ | grep -E 'ibs .*+qam'; then
    cmd=$(echo $@|sed -e 's|ibs \+qam|osc --apiurl https://api.suse.de qam|g' \
	              -e 's|S:M|SUSE:Maintenance|g')
  else
    cmd=$(echo $@|sed -e 's|qam|osc --apiurl https://api.suse.de qam|g' \
	              -e 's|S:M|SUSE:Maintenance|g')
  fi
  echo $cmd
  $cmd
}

exp_sm() {
  #echo $@
  ## Expand S:M
  cmd=$(echo $@|sed -e 's|ibs \+qam|osc --apiurl https://api.suse.de qam|g' \
	              -e 's|S:M|SUSE:Maintenance|g')
  echo $cmd
  $cmd
}

alias ibs='exp_sm ibs'
alias qam='ibs qam'

export KUBECONFIG=~/.kube/config

alias k='kubectl'
alias kks='k -n kube-system'
export PATH=$PATH:~/ltools/utils

## reset title
## trap 'echo -ne "\u001b]30; \a"' DEBUG
