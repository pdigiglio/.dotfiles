local textobject_keymaps = {
    ["ia"] = "@assignment.inner",
    -- Mnemonic: assignment (=) + left motion (h)
    ["=h"] = "@assignment.lhs",
    ["aa"] = "@assignment.outer",
    -- Mnemonic: assignment + right motion (l)
    ["=l"] = "@assignment.rhs",
    -- [""] = "@attribute.inner",
    -- [""] = "@attribute.outer",
    ["ib"] = "@block.inner",
    ["ab"] = "@block.outer",
    -- [""] = "@call.inner",
    -- [""] = "@call.outer",
    ["ic"] = "@class.inner",
    ["ac"] = "@class.outer",
    -- Doesn't seem to work:
    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/628
    -- ["i/"] = "@comment.inner",
    ["a/"] = "@comment.outer",
    ["ii"] = "@conditional.inner",
    ["ai"] = "@conditional.outer",
    -- [""] = "@frame.inner",
    -- [""] = "@frame.outer",
    ["if"] = "@function.inner",
    ["af"] = "@function.outer",
    ["il"] = "@loop.inner",
    ["al"] = "@loop.outer",
    -- [""] = "@number.inner",
    -- Mnemonic: "p" is also "paragraph". In C++, params are separated by ","
    ["i,"] = "@parameter.inner",
    ["a,"] = "@parameter.outer",
    -- [""] = "@regex.inner",
    -- [""] = "@regex.outer",
    -- Mnemonic: "r" for "return".
    ["ir"] = "@return.inner",
    ["ar"] = "@return.outer",
    -- [""] = "@scopename.inner",
    -- Mneminic: statements in C++ end with ";"
    ["a;"] = "@statement.outer",
}

local textobjects_ = {
    select = {
        enable = true,

        -- Automatically jump forward to textobj.
        lookahead = true,

        -- Set keymaps to select the objects.
        keymaps = textobject_keymaps,

        -- By changing the following table, ou can choose the select mode
        -- (default is charwise 'v')
        selection_modes = {
            ["@function.inner"] = "V",
            ["@function.outer"] = "V",
        },

        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace.
        -- include_surrounding_whitespace = false,
    },
    swap = {
        enable = true,
        swap_next = {
            -- Mnemonic: swap + left motion (l)
            ["<Leader>sl,"] = "@parameter.inner",
            ["<Leader>slf"] = "@function.outer",
        },
        swap_previous = {
            -- Mnemonic: swap + right motion (h)
            ["<leader>sh,"] = "@parameter.inner",
            ["<leader>shf"] = "@function.outer",
        },
    },
    move = {
        enable = true,
        -- whether to set jumps in the jumplist
        set_jumps = true,
        goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["],"] = { query = "@parameter.inner", desc = "Next parameter start" },
        },
        goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
        },
        goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[,"] = { query = "@parameter.inner", desc = "Previous parameter start" },
        },
        goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
        },
    },
    lsp_interop = {
        enable = true,
        border = 'none',
        floating_preview_opts = {},
        peek_definition_code = {
            ["<leader>df"] = "@function.outer",
            ["<leader>dF"] = "@class.outer",
        },
    },
}

local enable_textobjects = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
        -- Enable module textobjects
        textobjects = textobjects_,
    })
end

local make_motions_repeatable = function()
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- Repeat movement with ";" and ",".
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Make builtin "f", "F", "t", "T" also repeatable with ";" and ",".
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
end

return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {  "nvim-treesitter/nvim-treesitter" },
    config = function()
        enable_textobjects()
        make_motions_repeatable()
    end,
}
