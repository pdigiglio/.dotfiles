-- Setup 'nvim-treesitter-context'.

return {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
        -- Make the context persistent on all the windows.
        multiwindow = true,
        -- Calculate context based on "topline".
        mode = "topline",
        -- Maximum number of lines to show for a single context
        multiline_threshold = 1,
    }
}
