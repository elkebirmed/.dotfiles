# pyenv
set -gx PYENV_ROOT "{{ pyenv_root }}"
set -gx PATH "$PYENV_ROOT/bin" $PATH
pyenv init - | source
if test -d "$PYENV_ROOT/plugins/pyenv-virtualenv"
    pyenv virtualenv-init - | source
end
