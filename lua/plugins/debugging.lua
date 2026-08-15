return {
    {
        "mfussenegger/nvim-dap",
        -- without a trigger this never loaded, so none of the <leader>d maps existed
        keys = { { "<leader>d", desc = "Debug" } },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            require("config.dap.init")
        end,
    },
}
