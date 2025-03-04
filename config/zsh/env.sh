export EDITOR=nvim

# -- man
export MANWIDTH=80
export MANPAGER='nvim +Man!'

# -- Add Unreal paths
PATH="$PATH:$HOME/Project Repos/UnrealEngine/Engine/Binaries/Linux"
# -- Add path where pipx will make its binaries available to me.
PATH="$PATH:$HOME/.local/bin"
export PATH

# -- Python REPL
# Keep using ~/.inputrc.
# See: https://github.com/python/cpython/issues/118840
export PYTHON_BASIC_REPL=1

export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
