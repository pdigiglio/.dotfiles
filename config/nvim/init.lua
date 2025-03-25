-- init.lua: entry point for Nvim configuration.
-- 
-- TODO:
--  * read: https://learnvimscriptthehardway.stevelosh.com
--
-- Syntaxes for:
--  * mail
--  * offlineimap
--  * ogre mterial
--  * msmtp
--
--
-- foldcolumn = 4

-- The folder that contains my vim configuration.
local vim_cfg_dir = "~/.config/vim/"
local vimrc_path = vim_cfg_dir .. "vimrc"

-- Share my Vim config with Neovim.
vim.opt.runtimepath:prepend(vim_cfg_dir)
vim.opt.runtimepath:append(vim_cfg_dir .. "after")
vim.opt.packpath:prepend(vim_cfg_dir)

-- Source my vimrc, so that I don't need to duplicate my config here.
vim.cmd("source " .. vimrc_path)

-- Nvim messes up my terminal cursor. So I disable cursor shaping
vim.opt.guicursor = ""

-- Make sure to setup `mapleader` and `maplocalleader` before loading lazy.nvim
-- so that mappings are correct. I set these already in "vimrc".
--
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy (structured setup) as explained in:
-- https://lazy.folke.io/installation
require("config.lazy")

-- TODO:
--
--  * Figure out who provides the actual LSPs (i.e. which packages in Arch
--  provide the executuables)
local lsp = require("lspconfig")

local lsp_servers = {
    'hls', -- @requires@ haskell-language-server
    'clangd', -- @requires@ clangd
    'pyright', -- @requires@ pyright
    -- 'pylsp', -- @requires@ python-lsp-server
    'rust_analyzer', -- @requires@ rust-analyzer
    'texlab', -- @requires@ texlab
    'bashls', -- @requires@ bash-language-server
    'lua_ls', -- @requires@ lua-language-server
}

local lua_ls_setup = function(client)
    if client.workspace_folders then
        local path = client.workspace_folders[1].name
        local fs_stat = (vim.loop or vim.uv).fs_stat
        if fs_stat(path ..'/.luarc.json') or fs_stat(path ..'/.luarc.jsonc') then
            return
        end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
            checkThirdParty = false,
            library = {
                vim.env.VIMRUNTIME,
            }
        }
    })
end

local lsp_server_setups = {
    ['lua_ls'] = {
        on_init = lua_ls_setup,
        settings = { Lua = {} },
    }
}

local config_lsp = function()
    -- Add additional capabilities supported by nvim-cmp
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_lsp and cmp_lsp.default_capabilities() or nil

    for _, server in pairs(lsp_servers) do
        local lsp_server = lsp[server]
        local opts = lsp_server_setups[server]
        if not opts then
            opts = {}
        end

        if capabilities then
            opts.capabilities = capabilities
            -- vim.print(opts)
        end

        lsp_server.setup(opts)
    end

    -- print("lsp")
end

config_lsp()

-- Use LSP-based semantic analysis.
-- Move the cursor on an identifier and use `:Inspect` to check its tokens.
-- See: ttps://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
local on_lsp_token_update = function(args)
    local token = args.data.token
    if token.type ~= "variable" then return end
    
    local modifiers = token.modifiers
    if not (modifiers.globalScope or modifiers.fileScope)
    then
        return
    end

    local global_hl = modifiers.readonly and 'ConstGlobalVarHL' or 'MutableGlobalVarHL'
    vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, global_hl)
end

vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = 'LightCyan' })
vim.api.nvim_set_hl(0, '@lsp.type.property',  { italic = true })

-- underdotted: make it obvious writing to this var is dangerous.
vim.api.nvim_set_hl(0, 'MutableGlobalVarHL',  { bold = true, underdotted = true })
vim.api.nvim_set_hl(0, 'ConstGlobalVarHL',    { bold = true })
vim.api.nvim_create_autocmd('LspTokenUpdate', { callback = on_lsp_token_update })



-- Omnicomplete will display a preview window with the documentation of the
-- item curently selecting in the menu. The preview windows would remain open
-- without the followind autocommand.
-- vim.cmd("autocmd CompleteDone * pclose")

-- vim.opt.completeopt = "menu,preview,noinsert"

-- Fold with treesitter.
-- vim.opt.foldmethod = "expr"
-- The following is deprecated:
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Use this instead:
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- Don't automatically fold on entry.
-- vim.opt.foldenable = false

-- Share my Vim config with Neovim.
-- Note: set these AGAIN at the end of the file.
vim.opt.runtimepath:prepend(vim_cfg_dir)
vim.opt.runtimepath:append(vim_cfg_dir .. "after")
