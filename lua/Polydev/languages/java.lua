local utils = require("Polydev.utils")
local M = {}

function M.setup(user_opts)
    local opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("java"), user_opts or {})
    vim.api.nvim_create_user_command("JavaRun", M.run, {})
    for key, _ in pairs(opts.keybinds) do
	vim.keymap.set("n", key, ":JavaRun<CR>", { silent = true })
    end
end

function M.run()
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

return M
