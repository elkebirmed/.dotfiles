# yazi: start with `y` so exiting yazi (q) moves the shell into the last
# browsed directory. Quit with Q instead to stay put.
function y
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    set -l cwd (cat "$tmp" 2>/dev/null)
    if test -n "$cwd" -a "$cwd" != "$PWD" -a -d "$cwd"
        builtin cd "$cwd"
    end
    command rm -f -- "$tmp"
end
