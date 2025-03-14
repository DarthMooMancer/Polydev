local M = {}
M.close_key = nil
M.c_run = nil
M.new_python_file = nil
M.new_python_module_file = nil

M.config = {
    project_root = "~/Projects/Python",
    keybinds = {
	["<Esc>"] = "CloseTerminal",
	["<leader>pr"] = "PythonRun",
	["<leader>nf"] = "NewPythonFile",
	["<leader>nh"] = "NewPythonModuleFile",
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
	if command == "PythonRun" then M.c_run = key end
	if command == "NewPythonFile" then M.new_python_file = key end
	if command == "NewPythonModuleFile" then M.new_python_module_file = key end
    end
    vim.fn.system("source ./venv/bin/activate")

    vim.api.nvim_create_user_command("NewPythonModuleFile", M.create_new_module_file, {})
    vim.api.nvim_create_user_command("NewPythonFile", M.create_new_file, {})
    vim.api.nvim_create_user_command("PythonRun", M.run, {})

    vim.keymap.set("n", M.c_run, ":PythonRun<CR>", { silent = true })
    vim.keymap.set("n", M.new_python_file, ":NewPythonFile<CR>", { silent = true })
    vim.keymap.set("n", M.new_python_module_file, ":NewPythonModuleFile<CR>", { silent = true })
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
	if not project_name or project_name == "" then
	    print("Project creation canceled.")
	    return
	end

	local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
	for _, path in ipairs({ "/" .. project_name, "/tests" }) do
	    vim.fn.mkdir(project_root .. path, "p")
	end

	write_file(project_root .. "/" .. project_name .. "/__init__.py", "")
	write_file(project_root .. "/" .. project_name .. ".polydev", project_name)
	write_file(project_root .. "/main.py", [[
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
]])

	vim.fn.system("python -m venv " .. project_root .. "/venv && source " .. project_root .. "/venv/bin/activate")

	write_file(project_root .. "/requirements.txt", "")
	write_file(project_root .. "/setup.py", string.format([[
from setuptools import setup, find_packages

setup(
    name="%s",               # Name of the project
    version="0.1.0",                 # Version of the project
    packages=find_packages(),        # Automatically find packages
    install_requires=[               # List of dependencies
        "requests>=2.25.1",          # Example dependency
        "numpy>=1.20.0",             # Another example dependency
    ],
    author="Your Name",              # Author's name
    author_email="your.email@example.com", # Author's email
    description="A simple Python project", # Short description
    long_description=open('README.md').read(),  # Long description from README
    long_description_content_type="text/markdown", # Format of long description
    url="https://github.com/yourname/%s", # URL for the project repository
    classifiers=[                    # Some additional metadata
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.6",          # Minimum Python version required
)
]], project_name, project_name))

	vim.cmd("edit " .. project_root .. "/main.py")
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
        if not file_name or file_name == "" then 
            return print("File creation canceled.") 
        end

        -- Ensure filename has .py extension
        if not file_name:match("%.py$") then
            file_name = file_name .. ".py"
        end

        local root_dir = M.get_project_root()
        if not root_dir then 
            return print("Error: Project root not found.") 
        end

        -- Extract project name from root directory
        local project_name = vim.fn.fnamemodify(root_dir, ":t")
        local file_path = root_dir .. "/" .. project_name .. "/" .. file_name

        write_file(file_path, "")
    end)
end

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
	if vim.fn.isdirectory(dir .. "/src") == 1 or vim.fn.filereadable(dir .. "/*.polydev") == 1 then
	    return dir
	end
	dir = vim.fn.fnamemodify(dir, ":h")
    end
end

function M.run()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end
    local build_dir = root .. "/build"
    local files = vim.fn.glob(build_dir .. "/*.polydev", true, true)
    if #files == 0 then return print("Error: No .polydev file found in build directory.") end
    M.open_float_terminal("cd " .. build_dir .. " && ./" .. files[1]:match("([^/]+)%.polydev$"))
end

return M
