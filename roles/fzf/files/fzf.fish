# fzf
if test -r "$HOME/.config/fzf/themes/noctalia"
    set -gx FZF_DEFAULT_OPTS_FILE "$HOME/.config/fzf/themes/noctalia"
end
fzf --fish | source
