# Add ~/.local/bin to PATH (for dotfiles binaries like noctalia-theme, pi, omniroute)
if not string match -q "*:$HOME/.local/bin:*" ":$PATH:"
    set -gx PATH "$HOME/.local/bin" $PATH
end
