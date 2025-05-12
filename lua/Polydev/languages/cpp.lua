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
    local build_dir = root .. "/build"

    local cmd = "cd " .. build_dir .. " && cmake --build ."
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
	local run_cmd = "cd " .. build_dir .. " && ./" .. utils.get_project_name()
	utils.terminal({ run_cmd })
    end
end

return M
