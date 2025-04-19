---@module "Polydev.utils"
local utils = require("Polydev.utils")

---@module "Polydev.configs"
local config = require("Polydev.configs")

---@tyep table
local M = {}

---@tyep table
M.keybinds = {}

---@type nil|table
M.opts = nil

---@param opts table
function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, config.get("python"), opts or {})
    for key, command in pairs(M.opts.keybinds) do
	M.keybinds[command] = key
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

    if M.keybinds.PythonRun then
	vim.keymap.set("n", M.keybinds.PythonRun, ":PythonRun<CR>", { silent = true })
    end
    if M.keybinds.PythonPip then
	vim.keymap.set("n", M.keybinds.PythonPip, ":PythonPip<CR>", { silent = true })
    end
end

---@return string|nil
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

---@return string|nil
function M.install_dependency()
    vim.ui.input({ prompt = "Enter pip module: " }, function(pip_module)
	if not pip_module or pip_module == "" then
	    return print("Pip canceled")
	end

	utils.open_float_terminal("pip install " .. pip_module)
    end)
end

function M.run()
    local root = M.get_project_root()
    if not root then
	---@return nil
	return print("Error: Project root not found.")
    end

    local main_file = root .. "/main.py"
    if vim.fn.filereadable(main_file) == 0 then
	---@return nil
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

---@return table
return M
