-- Autocompletion setup

local nvim_cmp_setup = function()
    local luasnip = require('luasnip')
    luasnip.setup({})

    local expand = function(args)
        luasnip.lsp_expand(args.body)
    end

    local cmp = require('cmp')
    local select_next = function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end

    local select_prev = function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end

    local confirm = cmp.mapping.confirm ({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    })

    cmp.setup({
        snippet = { expand = expand, },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert({
            ['<C-Tab>'] = cmp.mapping.complete(),
            ['<C-n>'] = cmp.mapping(select_next, { 'i', 's' }),
            ['<C-p>'] = cmp.mapping(select_prev, { 'i', 's' }),
            -- Confirmation
            ['<C-y>'] = confirm,
            -- ['<Space>'] = confirm,
            ['<Tab>'] = confirm,
        }),
        sources = {
            {
                name = 'lazydev',
                -- set group index to 0 to skip loading LuaLS completions as
                -- lazydev recommends it
                group_index = 0,
            },
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
        }
    })
end

local build_luasnip = function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
    end
    return 'make install_jsregexp'
end

return { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            'L3MON4D3/LuaSnip',
            build = build_luasnip(),
        },
        'saadparwaiz1/cmp_luasnip',

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
    },
    config = nvim_cmp_setup,
}
