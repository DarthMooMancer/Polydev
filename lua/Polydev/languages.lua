local utils = require("Polydev.utils")
local configs = require("Polydev.configs")
local M = {}

M.languages = {
    java = {
	setup = function (self, user_opts)
	    local opts = vim.tbl_deep_extend("force", {}, configs.get("java"), user_opts or {})
	    vim.api.nvim_create_user_command("JavaRun", function() self:run() end, {})
	    for key, _ in pairs(opts.keybinds) do
		vim.keymap.set("n", key, ":JavaRun<CR>", { silent = true })
	    end
	end,
	run = function ()
	    local root = utils.get_project_root()

	    local cmd = string.format("javac -d %s %s", root .. "/build", root .. "/src/*.java")
	    local output = vim.fn.system(cmd)

	    if not vim.v.shell_error == 0 then
		local term_buf = utils.terminal({ cmd })
		vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(term_buf, 0, -1, false,
		    vim.list_extend({ "Error during compilation:" }, vim.split(output, "\n", { trimempty = true }))
		)
		vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
	    else
		utils.terminal({ "java -cp " .. root, "build" .. " Main" })
	    end
	end
    },
    c = {
	setup = function (self, user_opts)
	    local opts = vim.tbl_deep_extend("force", {}, configs.get("c"), user_opts or {})
	    vim.api.nvim_create_user_command("CRun", function () self:run() end, {})
	    for key, _ in pairs(opts.keybinds) do
		vim.keymap.set("n", key, ":CRun<CR>", { silent = true })
	    end
	end,
	run = function ()
	    local root = utils.get_project_root()
	    local build_dir = root .. "/build"

	    local cmd = "cd '" .. build_dir .. "' && cmake --build ."
	    local output = vim.fn.system(cmd)
	    local success = vim.v.shell_error == 0

	    if not success then
		local term_buf = utils.terminal({ cmd })
		vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(term_buf, 0, -1, false,
		    vim.list_extend({ "Error during compilation:" }, vim.split(output, "\n", { trimempty = true }))
		)
		vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
	    end
	    if success then
		local run_cmd = "cd '" .. build_dir .. "' && ./" .. utils.get_project_name()
		utils.terminal({ run_cmd })
	    end
	end
    },
    cpp = {
	setup = function (self, user_opts)
	    local opts = vim.tbl_deep_extend("force", {}, configs.get("cpp"), user_opts or {})
	    vim.api.nvim_create_user_command("CppRun", function () self:run() end, {})
	    for key, _ in pairs(opts.keybinds) do
		vim.keymap.set("n", key, ":CppRun<CR>", { silent = true })
	    end
	end,
	run = function ()
	    local root = utils.get_project_root()
	    local build_dir = root .. "/build"

	    local cmd = "cd '" .. build_dir .. "' && cmake --build ."
	    local output = vim.fn.system(cmd)
	    local success = vim.v.shell_error == 0

	    if not success then
		local term_buf = utils.terminal({ cmd })
		vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(term_buf, 0, -1, false,
		    vim.list_extend({ "Error during compilation:" }, vim.split(output, "\n", { trimempty = true }))
		)
		vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
	    end
	    if success then
		local run_cmd = "cd '" .. build_dir .. "' && ./" .. utils.get_project_name()
		utils.terminal({ run_cmd })
	    end
	end
    },
    html = {
	setup = function (user_opts)
	    vim.tbl_deep_extend("force", {}, configs.get("html"), user_opts or {})
	end
    },
    rust = {
	setup = function (self, user_opts)
	    local opts = vim.tbl_deep_extend("force", {}, configs.get("rust"), user_opts or {})
	    vim.api.nvim_create_user_command("RustRun", function () self:run() end, {})
	    for key, _ in pairs(opts.keybinds) do
		vim.keymap.set("n", key, ":RustRun<CR>", { silent = true })
	    end
	end,
	run = function ()
	    local root = utils.get_project_root()
	    if not root then return print("Error: Project root not found.") end

	    local cmd = { "cargo build" }
	    local output = vim.fn.system(table.concat(cmd))

	    if not vim.v.shell_error == 0 then
		local term_buf = utils.terminal(cmd)
		vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(term_buf, 0, -1, false,
		    vim.list_extend({ "Error during compilation:" }, vim.split(output, "\n", { trimempty = true }))
		)
		vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
	    else
		utils.terminal({ "cargo run" })
	    end
	end
    },
    python = {
	setup = function(self, user_opts)
	    local opts = vim.tbl_deep_extend("force", {}, configs.get("python"), user_opts or {})
	    vim.api.nvim_create_user_command("PythonPip", function () self:install_dependency() end, {})
	    vim.api.nvim_create_user_command("PythonRun", function () self:run() end, {})
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
	end,
	install_dependency = function ()
	    vim.ui.input({ prompt = "Enter pip module: " }, function(pip_module)
		if not pip_module or pip_module == "" then return print("Pip canceled") end
		utils.terminal({ "pip install " .. pip_module })
	    end)
	end,
	run = function ()
	    utils.terminal({ "python3 " .. utils.get_project_root(), "main.py" })
	end
    },
    lua = {
	setup = function (self, user_opts)
	    local opts = vim.tbl_deep_extend("force", {}, configs.get("lua"), user_opts or {})
	    vim.api.nvim_create_user_command("LuaRun", function () self:run() end, {})
	    for key, _ in pairs(opts.keybinds) do
		vim.keymap.set("n", key, ":LuaRun<CR>", { silent = true })
	    end
	end,
	run = function ()
	    local init_lua_path = utils.get_project_root() .. "/lua/" .. utils.get_project_name() .. "/init.lua"
	    if vim.fn.filereadable(init_lua_path) == 1 then
		utils.terminal({ "lua " .. init_lua_path })
	    end
	end
    },
}

return M
