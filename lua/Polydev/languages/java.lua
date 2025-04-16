local utils = require("Polydev.utils")
local M = {}

M.keybinds = {}
M.opts = nil

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("java"), opts or {})
    for key, command in pairs(M.opts.keybinds) do
	M.keybinds[command] = key
    end

    vim.api.nvim_create_user_command("JavaBuild", M.build, {})
    vim.api.nvim_create_user_command("JavaRun", M.run, {})

    if M.keybinds.JavaRun then
	vim.keymap.set("n", M.keybinds.JavaRun, ":JavaRun<CR>", { silent = true })
    end
    if M.keybinds.JavaBuild then
	vim.keymap.set("n", M.keybinds.JavaBuild, ":JavaBuild<CR>", { silent = true })
    end
end

function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled.") end
	local project_root = vim.fn.expand(M.opts.project_root) .. "/" .. project_name
	for _, path in ipairs({ "/src", "/build" }) do vim.fn.mkdir(project_root .. path, "p") end

	local main_java_content = [[
public class Main {
    public static void main(String[] args) {
	System.out.println("Hello, World!");
    }
}
]]
	utils.write_file(project_root .. "/src/Main.java", main_java_content)
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter class name: " }, function(class_name)
	if not class_name or class_name == "" then return print("Class creation canceled.") end
	local root_dir = vim.fn.expand("%:p:h"):match("(.*)/src")
	if not root_dir then return print("Error: src directory not found.") end
	local java_content = string.format([[
public class %s {
    // New File
}
]], class_name)

	utils.write_file(root_dir .. "/src/" .. class_name .. ".java", java_content)
    end)
end

function M.build()
    local project_root = vim.fn.expand("%:p:h"):match("(.*)/src")
    if not project_root then return print("Error: Could not detect project root directory.") end
    local out_dir = project_root .. "/build"

    vim.fn.mkdir(out_dir, "p")
    local compile_command = string.format("javac -d %s %s/*.java", out_dir, project_root .. "/src")
    local compile_status = vim.fn.system(compile_command)

    if vim.v.shell_error == 0 then
        print("Compilation successful!")
    else
        print("Error during compilation. Opening terminal for details...")
        local term_buf = utils.open_float_terminal(compile_command)
        vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
        vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, vim.split(compile_status, "\n", { trimempty = true }))
        vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
    end
end

function M.run()
    local project_root = vim.fn.expand("%:p:h"):match("(.*)/src")
    if not project_root then return print("Error: Must be inside the 'src' directory.") end
    utils.open_float_terminal("java -cp " .. project_root .. "/build" .. " Main")
end

return M
