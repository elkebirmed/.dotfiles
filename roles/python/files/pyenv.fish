# pyenv
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PYENV_ROOT/bin" $PATH
pyenv init - | source
if test -d "$PYENV_ROOT/plugins/pyenv-virtualenv"
    pyenv virtualenv-init - | source
end
