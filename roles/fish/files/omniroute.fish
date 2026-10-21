# Load OmniRoute API key for OpenCode and other AI tools
if test -f "$HOME/.omniroute/api-key"
    set -gx OMNIROUTE_API_KEY (cat "$HOME/.omniroute/api-key")
end