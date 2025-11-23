local fzf_lua_config = function()
    local fzf_lua = require('fzf-lua')
    fzf_lua.setup({ grep = { rg_glob = true } })

    vim.keymap.set('n', '<Leader>ff', fzf_lua.files)
    vim.keymap.set('n', '<Leader>fb', fzf_lua.buffers)
    vim.keymap.set('n', '<Leader>fo', fzf_lua.oldfiles)
    vim.keymap.set('n', '<Leader>fh', fzf_lua.helptags)
    vim.keymap.set('n', '<Leader>fm', fzf_lua.marks)

    vim.keymap.set('n', '<Leader>f*', fzf_lua.grep_cword)
    vim.keymap.set('v', '<Leader>f*', fzf_lua.grep_visual)
    vim.keymap.set('n', '<Leader>fg', -- fzf_lua.live_grep)
        function()
            fzf_lua.live_grep({
                -- no_esc = true,
                -- debug = true,
            })
        end)
end

return {
    "ibhagwan/fzf-lua",
    config = fzf_lua_config
}

-- return {
--     {
--         "junegunn/fzf",
--         -- build = "fzf#install()"
--         -- name = "fzf",
--         -- dir = "/usr/share/vim/vimfiles/plugin"
--         --dir = "~/.fzf",
--         --build = "./install --all",
--     },
--     {
--         "junegunn/fzf.vim",
--         dependencies = {  "junegunn/fzf" },
--     }
-- }
