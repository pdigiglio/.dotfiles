-- Setup 'nvim-lspconfig'.
--
-- TODO:
--
--  * Make the automatic indentation consistent with the formatting provided by
--  LSP. E.g. by default, clangd uses 2 spaces per tab but the default
--  indentation algorithm is not aware of this.
--
--  * By changing 'updatetime', the swapfile is written more often.
--

-- local n_lsp_map = function(key, func)
--     local map = ":lua vim.lsp.buf." .. func .. "()<Cr>"
--     vim.api.nvim_set_keymap("n", key, map, { noremap = true })
-- end

-- Highlight refs to item under the cursor if I don't move for 'updatetime'.
local highlight_refs = function(args)
    local bufnr = args.buf

    local augroup = "LspDocumentHighlight"
    vim.api.nvim_create_augroup(augroup, { clear = true })

    -- NOTE:
    --  * this also affects how often the swap file is written to disk.
    --  * There's no buf-local option for 'updatetime'.
    vim.opt.updatetime = 100

    local cmd = {
        buffer = bufnr,
        group = augroup,
        callback = vim.lsp.buf.document_highlight
    }

    local hold_events = { 'CursorHold', 'CursorHoldI' }
    for _, evt in pairs(hold_events) do
        vim.api.nvim_create_autocmd(evt, cmd)
    end

    cmd.callback = vim.lsp.buf.clear_references
    vim.api.nvim_create_autocmd('CursorMoved', cmd)
end

local set_keymaps = function(args)
    local modes = { "n" }
    local opts = {
        noremap = true,
        buffer = args.buf -- buffer-local mappings
    }

    -- Useful default key-mappings:
    --
    --  <C-w>d => maps to vim.diagnostic.open_float()
    --            (see readme from https://github.com/neovim/nvim-lspconfig)

    -- Override built-in 'gd' (go to local declaration).
    --
    -- NOTE: Many servers don't implement 'declaration'; use 'definition'
    -- (see |lsp-buf|).
    vim.keymap.set(modes, "gd", vim.lsp.buf.declaration, opts)

    -- <F12> comes from Visual Studio
    vim.keymap.set(modes, "<F12>", vim.lsp.buf.declaration, opts)

    -- "Go to definition" is already bound to <C-]> by lspconfig.
    -- vim.keymap.set(modes, "gd", vim.lsp.buf.definition, opts)

    -- Mnemonic: similar to '*' but syntax-aware.
    vim.keymap.set(modes, "<Leader>*", vim.lsp.buf.references, opts)

    -- Mnemonic: 's' for 'susbtitute' as in ':s[ubstitute]'
    --
    -- NOTE: this overrides the built-in '[N]gs' (sleep for N seconds).
    vim.keymap.set(modes, "gs", vim.lsp.buf.rename, opts)

    -- Lists all symbols in the current buffer in the quickfix window.
    -- Mnemonic: '>' reminds me of a tree structure.
    vim.keymap.set(modes, "g>", vim.lsp.buf.document_symbol, opts)
    vim.keymap.set(modes, "g<", vim.lsp.buf.incoming_calls, opts)

    -- Mnemonic: similar to 'K', which looks-up the word under the cursor.
    --
    -- NOTE:
    --  * 'K' is overridden by LSP to vim.lsp.buf.hover (see |lsp-defaults|).
    --  * <C-k> overrides a built-in key to enter digraphs (see |i_digraphs|).
    local sig_help = function()
        local diffModeOn = vim.api.nvim_get_option_value('diff', { win = 0 })
        local mode = vim.api.nvim_get_mode()["mode"]
        if diffModeOn and mode == "n"  then
            -- TODO: don't hard-code this command.
            vim.cmd("normal [c")
        else
            vim.lsp.buf.signature_help()
        end
    end
    -- vim.keymap.set({"n","i"}, "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set({"n","i"}, "<C-k>", sig_help, opts)

    -- <C-.> comes from Visual Studio
    vim.keymap.set(modes, "<C-.>", vim.lsp.buf.code_action, opts)
end

local on_attach = function(args)
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
        return
    end

    set_keymaps(args)
    if client.name ~= "pylsp" then
        -- This kills my CPU with pylsp
        highlight_refs(args)
    end
end

local config = function()
    local au_name = "LspAttach"
    local au_group = vim.api.nvim_create_augroup(au_name .. "Group", { clear = true })
    vim.api.nvim_create_autocmd(au_name, { group = au_group, callback = on_attach })
end

return {
    "neovim/nvim-lspconfig",
    config = config,
}
