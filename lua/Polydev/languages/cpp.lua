local utils = require("Polydev.utils")
local M = {}

M.keybinds = {}
M.opts = nil

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("cpp"), opts or {})
    for key, command in pairs(M.opts.keybinds) do
	M.keybinds[command] = key
    end

    vim.api.nvim_create_user_command("NewCppHeaderFile", M.create_new_header_file, {})
    vim.api.nvim_create_user_command("CppRun", M.run, {})

    if M.keybinds.CppRun then
	vim.keymap.set("n", M.keybinds.CppRun, ":CppRun<CR>", { silent = true })
    end
    if M.keybinds.NewCppHeaderFile then
	vim.keymap.set("n", M.keybinds.NewCppHeaderFile, ":NewCppHeaderFile<CR>", { silent = true })
    end
end

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
	if vim.fn.isdirectory(dir .. "/src") == 1 or vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1 then
	    return dir
	end
	dir = vim.fn.fnamemodify(dir, ":h")
    end
end

function M.create_new_header_file()
    vim.ui.input({ prompt = "Enter header file name: " }, function(header_name)
	if not header_name then return print("Header file creation canceled.") end
	local root_dir = M.get_project_root()
	if not root_dir then return print("Error: Project root not found.") end
	local guard_macro = header_name:upper():gsub("[^A-Z0-9]", "_") .. "_HPP"
	local content = string.format([[
#ifndef %s
#define %s

#include <iostream>

// Function prototypes
void example_function();

#endif // %s
]], guard_macro, guard_macro, guard_macro)
	utils.write_file(root_dir .. "/include/" .. header_name .. ".hpp", content)
    end)
end

function M.run()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end
    local build_dir = root .. "/build"

    local cmd = "cd " .. build_dir .. " && cmake --build ."
    local output = vim.fn.system(cmd)
    local success = vim.v.shell_error == 0

    if not success then
	local term_buf = utils.open_float_terminal(cmd)
	vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(term_buf, 0, -1, false,
	    vim.list_extend({ "Error during compilation:" }, vim.split(output, "\n", { trimempty = true }))
	)
	vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
    end

    if success then
	local files = vim.fn.glob(build_dir .. "/*.polydev", true, true)
	if #files == 0 then return print("Error: No .polydev file found in build directory.") end
	utils.open_float_terminal("cd " .. build_dir .. " && ./" .. files[1]:match("([^/]+)%.polydev$"))
    end
end

return M
