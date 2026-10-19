# fzf
if [ -r "$HOME/.config/fzf/themes/noctalia" ]; then
    export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/themes/noctalia"
fi
eval "$(fzf --bash)"
