export EDITOR=nvim

# -- man
export MANWIDTH=80
export MANPAGER='nvim +Man!'

# -- Add path where pipx will make its binaries available to me.
PATH="$PATH:$HOME/.local/bin"
export PATH

# -- Python REPL
# Keep using ~/.inputrc.
# See: https://github.com/python/cpython/issues/118840
export PYTHON_BASIC_REPL=1

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export EDITRC="$XDG_CONFIG_HOME/editline/editrc"

# -- clangd
#
# The following flags are taken from: 
# https://www.reddit.com/r/cpp/comments/ucz051/how_to_speed_up_clangd_on_big_project
#
# NOTE:
#  - Should they be comma separated or is it fine?
#  - How to check if clangd is using them?
#
export CLANGD_FLAGS="$CLANGD_FLAGS -j=8 --malloc-trim --background-index --pch-storage=memory"
