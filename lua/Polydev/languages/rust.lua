local utils = require("Polydev.utils")
local M = {}

M.keybinds = {}
M.opts = {}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("rust"), opts or {})
    for key, command in pairs(M.opts.keybinds) do
	M.keybinds[command] = key
    end

    vim.api.nvim_create_user_command("RustRun", M.run, {})

    if M.keybinds.RustRun then
	vim.keymap.set("n", M.keybinds.RustRun, ":RustRun<CR>", { silent = true })
    end
end

function M.run()
    local root = utils.get_project_root()
    if not root then return print("Error: Project root not found.") end

    local cmd = "cargo build"
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
	utils.open_float_terminal("cargo run")
    end
end

return M
