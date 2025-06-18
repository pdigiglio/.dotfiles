local set_keymaps = function()
    local dap = require('dap')

    -- vim.keymap.set('n', '<F1>',  dap.clear_breakpoints)
    vim.keymap.set('n', '<F2>',  dap.terminate)
    vim.keymap.set('n', '<F3>',  dap.restart)
    vim.keymap.set('n', '<F4>',  dap.run_last)
    vim.keymap.set('n', '<F5>',  dap.continue)

    vim.keymap.set('n', '<F6>',  dap.focus_frame)
    vim.keymap.set('n', '<F10>', dap.step_over)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<F12>', dap.step_out)


    local toggle_logpoint = function()
        local log_msg = vim.fn.input('Log point message: ') 
        dap.toggle_breakpoint(nil, nil, log_msg)
    end
    vim.keymap.set('n', '<F7>', dap.list_breakpoints)
    vim.keymap.set('n', '<F8>',     toggle_logpoint)
    vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)

    -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
    -- vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    -- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    -- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)

    local widgets = require('dap.ui.widgets')
    vim.keymap.set({'n', 'v'}, '<Leader>dh', widgets.hover)
    vim.keymap.set({'n', 'v'}, '<Leader>dp', widgets.preview)

    vim.keymap.set('n', '<Leader>df', function()
        -- local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
        -- local widgets = require('dap.ui.widgets')
        -- widgets.centered_float(widgets.scopes)
        widgets.sidebar(widgets.scopes)
    end)

    local plugin = 'dap'
    dap.listeners.after.event_initialized[plugin] = function() dap.repl.open() end
    dap.listeners.before.event_terminated[plugin] = function() dap.repl.close() end
    dap.listeners.before.event_exited[plugin]     = function() dap.repl.close() end
end

adapters = {
    -- @requires@ gdb (>= 14.0)
    ['gdb'] = {
        type = 'executable',
        command = 'gdb',
        args = {
            '--interpreter=dap',
            '--eval-command',
            'set print pretty on'
        },
    },
    ['lldb'] = {
        type = 'executable',
        -- command = 'lldb-dap',
        command = '/usr/share/rider/plugins/cidr-debugger-plugin/bin/lldb/linux/x64/bin/lldb-dap',
    },
    -- @requires@ codelldb (>= 1.11.0)
    ['codelldb'] = {
        type = 'executable',
        command = 'codelldb',
    },
}

local setup_gdb = function()
    local dap = require("dap")
    require("dap.ext.vscode").load_launchjs()

    dap.adapters = adapters

    local program = function()
        -- NOTE: This would be a good point to compile before debugging.
        -- See: https://alighorab.github.io/neovim/nvim-dap/
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end

    local pid = function()
        local name = vim.fn.input('Executable name (filter): ')
        return require("dap.utils").pick_process({ filter = name })
    end

    local dap_configs = {
        {
            name = "[gdb] launch",
            type = "gdb",
            request = "launch",
            program = program,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
            externalConsole = true,
        },
        {
            name = "[gdb] attach",
            type = "gdb",
            request = "attach",
            program = program,
            pid = pid,
            cwd = '${workspaceFolder}',
            externalConsole = true,
        },
        -- {
        --     name = 'Attach to gdbserver :1234',
        --     type = 'gdb',
        --     request = 'attach',
        --     target = 'localhost:1234',
        --     program = program,
        --     cwd = '${workspaceFolder}',
        --     externalConsole = true
        -- },
        {
            name = '[lldb] launch',
            type = 'lldb',
            request = 'launch',
            program = program,
            cwd = '${workspaceFolder}',
            runInTerminal = true,
            stopOnEntry = false,
            args = {}
        },
        {
            name = '[lldb] attach',
            type = 'lldb',
            request = "attach",
            -- program = program,
            pid = pid,
            cwd = '${workspaceFolder}',
            runInTerminal = true,
            stopOnEntry = false,
            args = {}
        },
    }

    dap.configurations.c = dap_configs
    dap.configurations.cpp = dap_configs
    dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/kitty",
        args = { "-e" },
    }

    -- dap.defaults.fallback.force_external_terminal = true
end

local config = function()
    set_keymaps()
    -- vim.api.nvim_create_autocmd(
    --     { 'FileType' },
    --     {
    --         pattern = 'dap-repl',
    --         callback = function()
    --             require('dap.ext.autocompl').attach()
    --         end
    --     })
    setup_gdb()
end

local ui_config = function()
    local dapui = require("dapui")
    dapui.setup({})

    local listeners = require("dap").listeners
    local evt = "dapui_config"
    listeners.after.event_initialized[evt] = dapui.open
    listeners.before.event_terminated[evt] = dapui.close
    listeners.before.event_exited[evt]     = dapui.close

end

-- local persistent_bp_config = function()
--     local pb = require('persistent-breakpoints')
--     pb.setup({ load_breakpoints_event = { "BufReadPost" } })
--
--
--     -- vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
--     -- vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
--     -- vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
--     -- vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
--     -- vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
--
--     local pba = require('persistent-breakpoints.api')
--     local opts = { noremap = true, silent = true }
--     vim.keymap.set("n", "<F9>", pba.toggle_breakpoint, opts)
--     -- vim.keymap.set("n", "<YourKey2>", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
--     -- vim.keymap.set("n", "<YourKey3>", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
--     -- vim.keymap.set("n", "<YourKey4>", "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>", opts)
-- end

local nvim_dap = "mfussenegger/nvim-dap"
return {
    {
        nvim_dap,
        config = config
    },
    -- {
    --     "rcarriga/nvim-dap-ui",
    --     -- lazy = false,
    --     dependencies = {
    --         nvim_dap,
    --         "nvim-neotest/nvim-nio"
    --     },
    --     config = ui_config,
    -- },
    -- {
    --     "Weissle/persistent-breakpoints.nvim",
    --     config = persistent_bp_config,
    -- }
}
