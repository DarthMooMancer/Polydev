local utils = require("Polydev.utils")
local M = {}

M.keybinds = {}
M.opts = {}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("cpp"), opts or {})
    vim.api.nvim_create_user_command("CppRun", M.run, {})
    for key, command in pairs(M.opts.keybinds) do
	M.keybinds[command] = key
    end

    if M.keybinds.CppRun then
	vim.keymap.set("n", M.keybinds.CppRun, ":CppRun<CR>", { silent = true })
    end
end

function M.run()
    local root = utils.get_project_root()
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
    else
	utils.open_float_terminal("cd " .. build_dir .. " && ./" .. utils.get_project_name())
    end
end

return M
