return {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
        { "<leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
        { "<leader>dsi", function() require("dap").step_into() end, desc = "DAP step into" },
        { "<leader>dso", function() require("dap").step_over() end, desc = "DAP step over" },
        { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle" },
    },
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        dap.adapters.python = function(cb, config)
            if config.request == "attach" then
                cb({
                    type = "server",
                    host = config.host or "127.0.0.1",
                    port = config.port or 5678,
                })
                return
            end

            cb({
                type = "executable",
                command = "python3",
                args = {"-m", "debugpy.adapter"},
            })
        end

        dap.adapters.delve = {
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = {"dap", "-l", "127.0.0.1:${port}"},
            },
        }

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = "codelldb",
                args = {"--port", "${port}"},
            },
        }

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
            },
        }
        dap.configurations.go = {
            {
                type = "delve",
                request = "launch",
                name = "Launch file",
                program = "${file}",
            },
        }
        dap.configurations.rust = {
            {
                type = "codelldb",
                request = "launch",
                name = "Launch file",
                program = "${file}",
            },
        }
    end,
}
