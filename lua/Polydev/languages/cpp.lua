local utils = require("Polydev.utils")
local M = {}

function M.setup(user_opts)
    local opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("cpp"), user_opts or {})
    vim.api.nvim_create_user_command("CppRun", M.run, {})
    for key, _ in pairs(opts.keybinds) do
	vim.keymap.set("n", key, ":CppRun<CR>", { silent = true })
    end
end

function M.run()
    local root = utils.get_project_root()

    local cmd = { "cd " .. root, "build", " && cmake --build ." }
    local output = vim.fn.system(table.concat(cmd, "/"))

    if not vim.v.shell_error == 0 then
	local term_buf = utils.open_float_terminal(cmd)
	vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(term_buf, 0, -1, false,
	    vim.list_extend({ "Error during compilation:" }, vim.split(output, "\n", { trimempty = true }))
	)
	vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
    else
	utils.open_float_terminal({ "cd " .. root, "build" .. " && .", utils.get_project_name() })
    end
end

return M
