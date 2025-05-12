local utils = require("Polydev.utils")
local M = {}

M.keybinds = {}
M.opts = {}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("java"), opts or {})
    for key, command in pairs(M.opts.keybinds) do
	M.keybinds[command] = key
    end

    vim.api.nvim_create_user_command("JavaRun", M.run, {})

    if M.keybinds.JavaRun then
	vim.keymap.set("n", M.keybinds.JavaRun, ":JavaRun<CR>", { silent = true })
    end
end

function M.run()
    local root = utils.get_project_root()
    local out_dir = root .. "/build"

    if not utils.is_dir(out_dir) then
	vim.fn.mkdir(out_dir, "p")
    end

    local compile_command = string.format("javac -d %s %s/*.java", out_dir, root .. "/src")
    local compile_status = vim.fn.system(compile_command)

    if vim.v.shell_error == 0 then
	utils.open_float_terminal("java -cp " .. root .. "/build" .. " Main")
    else
        print("Error during compilation. Opening terminal for details...")
        local term_buf = utils.open_float_terminal(compile_command)
        vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
        vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, vim.split(compile_status, "\n", { trimempty = true }))
        vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
    end
end

return M
