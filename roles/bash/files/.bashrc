# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Include external secrets/environment variables
if [ -f "$HOME/.config/bash/secrets.sh" ]; then
    source "$HOME/.config/bash/secrets.sh"
fi