local set_keymaps = function()
    local dap = require("dap")
    vim.keymap.set('n', '<F5>',  dap.continue)
    vim.keymap.set('n', '<F10>', dap.step_over)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<F12>', dap.step_out)
    vim.keymap.set('n', '<F9>',  dap.toggle_breakpoint)

    -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
    -- vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    -- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    -- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)

    local dap_ui_w = require("dap.ui.widgets")
    vim.keymap.set({'n', 'v'}, '<Leader>dh', dap_ui_w.hover)
    vim.keymap.set({'n', 'v'}, '<Leader>dp', dap_ui_w.preview)

    vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
    end)
end

local setup_gdb = function()
    local dap = require("dap")

    -- @requires@ gdb (>= 14.0)
    dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
    }

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
            name = "Launch",
            type = "gdb",
            request = "launch",
            program = program,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
            externalConsole = true,
        },
        {
            name = "Select and attach to process",
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
        --     cwd = '${workspaceFolder}'
        -- },
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

local persistent_bp_config = function()
    local pb = require('persistent-breakpoints')
    pb.setup({ load_breakpoints_event = { "BufReadPost" } })


    -- vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
    -- vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
    -- vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
    -- vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
    -- vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)

    local pba = require('persistent-breakpoints.api')
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<F9>", pba.toggle_breakpoint, opts)
    -- vim.keymap.set("n", "<YourKey2>", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
    -- vim.keymap.set("n", "<YourKey3>", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
    -- vim.keymap.set("n", "<YourKey4>", "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>", opts)
end

local nvim_dap = "mfussenegger/nvim-dap"
return {
    {
        nvim_dap,
        config = config
    },
    {
        "rcarriga/nvim-dap-ui",
        -- lazy = false,
        dependencies = {
            nvim_dap,
            "nvim-neotest/nvim-nio"
        },
        config = ui_config,
    },
    {
        "Weissle/persistent-breakpoints.nvim",
        config = persistent_bp_config,
    }
}
