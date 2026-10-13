# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Source user drop-ins (e.g. the omp() wrapper installed by the ai role)
for _dropin in "$HOME"/.config/bash/*.sh; do
    [ -r "$_dropin" ] && . "$_dropin"
done
unset _dropin
