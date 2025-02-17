return {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function ()
        local py_dap = require("dap-python")
        py_dap.setup("python3")
    end,
}
