-- Setup 'nvim-treesitter'.
--
-- Note:
--  * To see the parse tree `:InspectTree`.
--  * To enable individual features by hand `:TSBufEnable`
--

local ensure_installed = {
    -- It's recommended to have these 5 always installed.
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    --
    "bash",
    "cmake",
    "comment",
    "cpp",
    "doxygen",
    "haskell",
    -- "latex", -- requires tree-sitter-cli
    "markdown",
    "python",
    "rust",
}

local ignore_install = {
    "gitcommit"
}

-- These keymaps allows to create a syntax-aware visual selection.
local incremental_selection = {
    enable = true,
    keymaps = {
        -- Mnemonic: visual (selection) start
        init_selection = "<Leader>vs",
        -- Mnemonic: visual (selection) increment
        node_incremental = "<Leader>vi",
        -- Mnemonic: visual (selection) decrement
        node_decremental = "<Leader>vd",
        -- Mnemonic: select (selection) context
        scope_incremental = "<Leader>vc",
    }
}

local opts = {
    -- Automatically install parsers I don't have already installed.
    auto_install = true,
    -- Except the ones I specity in this table.
    ignore_install = ignore_install,
    -- Install in background.
    sync_install = false,

    ensure_installed = ensure_installed,
    incremental_selection = incremental_selection,

    highlight = {
        -- Enable syntax highlighting via treesitter.
        enable = true,

        -- Setting "ignore_install" doesn't seem to be enough. So just disable
        -- highlighting:
        disable = ignore_install,

        -- Disable regex (default vim) highlighting.
        additional_vim_regex_highlighting = false,
    },

    indent = {
        -- Let treesitter take care of indentation.
        --
        -- TODO: how does this work with lsp and custom formatters like clang?
        enable = true
    },
}

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local cfg = require('nvim-treesitter.configs')
        cfg.setup(opts)
    end,
}
