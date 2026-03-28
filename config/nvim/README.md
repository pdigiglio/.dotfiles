## Removing a plugin

Lazy stores its plugins in:

```
$XDG_DATA_HOME/nvim/lazy
```

Check there to make sure a plugin is removed.


## Building from source

To build `nvim` from source, follow the guide on the
[wiki](https://github.com/neovim/neovim/wiki/Building-Neovim/688be28f98c18e73b5043879b5963287a9b13d6c).

Another option is to have a look at what the [`neovim-git` PKGBUILD on
AUR](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=neovim-git) does.


## Profiling startup

When opening big files, `nvim` can be significantly slower than `vim`.  To dump
information about the startup time:

```sh
nvim --startuptime time.dump /file/to/open
```

This works both on `nvim` and `vim`.  In my experience, the slowdown is usually
due to tree-sitter (or its related functionalities); e.g. the tree-sitter based
folding is quite slow.
