local M = {}
M.close_key = nil
M.java_build = nil
M.java_run = nil
M.new_java_file = nil

M.config = {
    project_root = "~/Projects/Java",
    keybinds = {
	["<Esc>"] = "CloseTerminal",
	["<leader>pb"] = "JavaBuild",
	["<leader>pr"] = "JavaRun",
	["<leader>nf"] = "NewJavaFile",
    },
    terminal = {
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	top_padding = 0,
	border = true,
	number = true,
	relativenumber = true,
	scroll = true,
    }
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    for key, command in pairs(M.config.keybinds) do
	if command == "CloseTerminal" then M.close_key = key end
	if command == "JavaBuild" then M.java_build = key end
	if command == "JavaRun" then M.java_run = key end
	if command == "NewJavaFile" then M.new_java_file = key end
    end

    vim.keymap.set("n", M.java_build, ":JavaBuild<CR>", { silent = true })
    vim.keymap.set("n", M.java_run, ":JavaRun<CR>", { silent = true })
    vim.keymap.set("n", M.new_java_file, ":NewJavaFile<CR>", { silent = true })

    vim.api.nvim_create_user_command("NewJavaFile", M.create_new_file, {})
    vim.api.nvim_create_user_command("JavaBuild", M.build, {})
    vim.api.nvim_create_user_command("JavaRun", M.run, {})
end

function M.open_float_terminal(cmd)
    local ui = vim.api.nvim_list_uis()[1]
    local term_cfg = M.config.terminal

    local width = math.max(1, math.floor(ui.width * 0.9) - term_cfg.left_padding - term_cfg.right_padding)
    local height = math.max(1, math.floor(ui.height * 0.9) - term_cfg.top_padding - (term_cfg.bottom_padding + 1))
    local row = math.max(1, math.floor((ui.height - height) / 2) + term_cfg.top_padding)
    local col = math.max(1, math.floor((ui.width - width) / 2) + term_cfg.left_padding)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
	relative = "editor",
	width = width,
	height = height,
	row = row,
	col = col,
	style = "minimal",
	border = term_cfg.border and "rounded" or "none",
    })

    vim.api.nvim_win_set_option(win, "winblend", vim.o.pumblend)
    vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Pmenu,FloatBorder:Pmenu")
    vim.api.nvim_win_set_option(win, "cursorline", true)
    if(term_cfg.number == true) then
	vim.api.nvim_win_set_option(win, "number", true)
	if(term_cfg.relativenumber == true) then
	    vim.api.nvim_win_set_option(win, "relativenumber", true)
	end
    end
    if(term_cfg.scroll == true) then
	vim.api.nvim_win_set_option(win, "scrolloff", 5)
    end

    vim.fn.termopen(cmd)
    vim.api.nvim_buf_set_keymap(buf, "n", M.close_key, "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
    return buf, win
end

local function write_file(path, content)
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
    print(path .. " created successfully!")
end

function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled.") end
	local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
	for _, path in ipairs({ "/src", "/build" }) do vim.fn.mkdir(project_root .. path, "p") end

	local main_java_content = [[
public class Main {
    public static void main(String[] args) {
	System.out.println("Hello, World!");
    }
}
]]

	write_file(project_root .. "/src/Main.java", main_java_content)
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

	write_file(root_dir .. "/src/" .. class_name .. ".java", java_content)
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
        local term_buf = M.open_float_terminal(compile_command)
        vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
        vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, vim.split(compile_status, "\n", { trimempty = true }))
        vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
    end
end

function M.run()
    local project_root = vim.fn.expand("%:p:h"):match("(.*)/src")
    if not project_root then return print("Error: Must be inside the 'src' directory.") end
    M.open_float_terminal("java -cp " .. project_root .. "/build" .. " Main")
end

return M
