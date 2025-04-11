local M = {}
local utils = require("Polydev.utils")

M.rust_build = nil
M.rust_run = nil

M.config = {
    project_root = "~/Projects/Rust",
    keybinds = {
	["<leader>pb"] = "RustBuild",
	["<leader>pr"] = "RustRun",
    },
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    for key, command in pairs(M.config.keybinds) do
	if command == "RustBuild" then M.rust_build = key end
	if command == "RustRun" then M.rust_run = key end
    end

    vim.api.nvim_create_user_command("RustBuild", M.build, {})
    vim.api.nvim_create_user_command("RustRun", M.run, {})

    vim.keymap.set("n", M.rust_build, ":RustBuild<CR>", { silent = true })
    vim.keymap.set("n", M.rust_run, ":RustRun<CR>", { silent = true })
end

function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled.") end
	local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
	vim.fn.system("cargo new " .. project_root)
	vim.cmd("edit " .. project_root .. "/src/main.rs")
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(class_name)
	if not class_name or class_name == "" then return print("File creation canceled.") end
	local root_dir = M.get_project_root()
	if not root_dir then return print("Error: Project root not found.") end
	utils.write_file(root_dir .. "/src/" .. class_name .. ".rs", "")
    end)
end

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
	if vim.fn.isdirectory(dir .. "/src") == 1 then
	    return dir
	end
	dir = vim.fn.fnamemodify(dir, ":h")
    end
end

function M.build()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end
    local cmd = "cargo build"
    local term_buf = utils.open_float_terminal(cmd)
    vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
    local output = vim.fn.system(cmd)
    local success = vim.v.shell_error == 0
    vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, vim.list_extend({ success and "Compilation successful!" or "Error during compilation:" }, vim.split(output, "\n", { trimempty = true })))
    vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
end

function M.run()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end
    utils.open_float_terminal("cargo run")
end

return M
