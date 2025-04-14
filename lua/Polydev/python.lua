local M = {}
local utils = require("Polydev.utils")

M.c_run = nil
M.new_pip_module = nil
M.run_custom = nil

M.config = {
    project_root = "~/Projects/Python",
    keybinds = {
	["<leader>pr"] = "PythonRun",
	["<leader>pb"] = "PythonPip",
	["<leader>pc"] = "PythonCustom"
    },
}

function M.setup(opts)
    M.config = utils.deep_merge_with_defaults(opts, M.config)

    for key, command in pairs(M.config.keybinds) do
	if command == "PythonRun" then M.c_run = key end
	if command == "PythonPip" then M.new_pip_module = key end
	if command == "PythonCustom" then M.run_custom = key end
    end

    local root = M.get_project_root()
    if root then
	local venv_path = root .. "/venv/bin/activate"
	if vim.fn.filereadable(venv_path) == 1 then
	    vim.env.VIRTUAL_ENV = venv_path
	    vim.env.PATH = root .. "/venv/bin:" .. vim.env.PATH
	end
    end

    vim.api.nvim_create_user_command("PythonPip", M.install_dependency, {})
    vim.api.nvim_create_user_command("PythonRun", M.run, {})
    vim.api.nvim_create_user_command("PythonCustom", M.custom_run, {})


    vim.keymap.set("n", M.c_run, ":PythonRun<CR>", { silent = true })
    vim.keymap.set("n", M.new_pip_module, ":PythonPip<CR>", { silent = true })
    vim.keymap.set("n", M.run_custom, ":PythonCustom<CR>", { silent = true })
end

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
	if vim.fn.isdirectory(dir .. "/venv") == 1 or vim.fn.filereadable(dir .. "/main.py") == 1 then
	    return dir
	end
	dir = vim.fn.fnamemodify(dir, ":h")
    end
    return nil
end

function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then
	    print("Project creation canceled.")
	    return
	end

	local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
	for _, path in ipairs({ "/include" }) do
	    vim.fn.mkdir(project_root .. path, "p")
	end

	utils.write_file(project_root .. "/main.py", [[
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
]])

	utils.write_file(project_root .. "/include/__init__.py", "")
	utils.write_file(project_root .. "/requirements.txt", "")
	utils.write_file(project_root .. "/setup.py", string.format([[
from setuptools import setup, find_packages

setup(
    name="%s",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[],
    python_requires=">=3.6",
)
]], project_name))

	vim.cmd("edit " .. project_root .. "/main.py")
	local venv_path = project_root .. "/venv"
	vim.fn.system("python3 -m venv " .. venv_path)
	vim.g.python3_host_prog = venv_path .. "/bin/python"
	vim.fn.setenv("VIRTUAL_ENV", venv_path)
	vim.fn.setenv("PATH", venv_path .. "/bin:" .. vim.fn.getenv("PATH"))

	print("Virtual environment activated for " .. project_name)
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
	if not file_name or file_name == "" then
	    return print("File creation canceled.")
	end

	if not file_name:match("%.py$") then
	    file_name = file_name .. ".py"
	end

	local root_dir = M.get_project_root()
	if not root_dir then
	    return print("Error: Project root not found.")
	end

	local file_path = root_dir .. "/include/" .. file_name
	utils.write_file(file_path, "")
    end)
end

function M.install_dependency()
    vim.ui.input({ prompt = "Enter pip module: " }, function(pip_module)
	if not pip_module or pip_module == "" then
	    return print("Pip canceled")
	end

	utils.open_float_terminal("pip install " .. pip_module)
    end)
end

function M.custom_run()
    vim.ui.input({ prompt = "Enter File Name: " }, function(custom_file)
	if not custom_file or custom_file == "" then
	    return print("Run canceled")
	end

	local root = M.get_project_root()
	-- Detect current shell
	local shell = vim.fn.getenv("SHELL") or ""
	local venv_cmd

	if shell:match("fish") then
	    local venv_fish = root .. "/venv/bin/activate.fish"
	    venv_cmd = vim.fn.filereadable(venv_fish) == 1 and "source " .. venv_fish .. " && " or ""
	else
	    local venv_bash = root .. "/venv/bin/activate"
	    venv_cmd = vim.fn.filereadable(venv_bash) == 1 and "source " .. venv_bash .. " && " or ""
	end

	utils.open_float_terminal(venv_cmd .. "python3 " .. custom_file .. ".py")
    end)
end

function M.run()
    local root = M.get_project_root()
    if not root then
        return print("Error: Project root not found.")
    end

    local main_file = root .. "/main.py"
    if vim.fn.filereadable(main_file) == 0 then
        return print("Error: main.py not found in project root.")
    end

    -- Detect current shell
    local shell = vim.fn.getenv("SHELL") or ""
    local venv_cmd

    if shell:match("fish") then
        local venv_fish = root .. "/venv/bin/activate.fish"
        venv_cmd = vim.fn.filereadable(venv_fish) == 1 and "source " .. venv_fish .. " && " or ""
    else
        local venv_bash = root .. "/venv/bin/activate"
        venv_cmd = vim.fn.filereadable(venv_bash) == 1 and "source " .. venv_bash .. " && " or ""
    end

    utils.open_float_terminal(venv_cmd .. "python3 " .. main_file)
end

return M
