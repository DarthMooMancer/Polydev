local utils = require("Polydev.utils")
local M = {}

function M.setup(user_opts)
    local opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("python"), user_opts or {})
    vim.api.nvim_create_user_command("PythonPip", M.install_dependency, {})
    vim.api.nvim_create_user_command("PythonRun", M.run, {})
    for key, command in pairs(opts.keybinds) do
	if command == "PythonRun" then
	    vim.keymap.set("n", key, ":PythonRun<CR>", { silent = true })
	end
	if command == "PythonPip" then
	    vim.keymap.set("n", key, ":PythonPip<CR>", { silent = true })
	end
    end

    local root = utils.get_project_root()
    if root then
	local venv_path = root .. "/venv/bin/activate"
	if vim.fn.filereadable(venv_path) == 1 then
	    vim.env.VIRTUAL_ENV = venv_path
	    vim.env.PATH = root .. "/venv/bin:" .. vim.env.PATH
	end
    end
end

function M.install_dependency()
    vim.ui.input({ prompt = "Enter pip module: " }, function(pip_module)
	if not pip_module or pip_module == "" then return print("Pip canceled") end
	utils.open_float_terminal({ "pip install " .. pip_module })
    end)
end

function M.run()
    utils.open_float_terminal({ "python3 " .. utils.get_project_root(), "main.py" })
end

return M
