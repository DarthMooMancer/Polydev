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

    local width = math.floor(ui.width * 0.9) - term_cfg.left_padding - term_cfg.right_padding
    local height = math.floor(ui.height * 0.9) - term_cfg.top_padding - term_cfg.bottom_padding
    local row = math.floor((ui.height - height) / 2) + term_cfg.top_padding
    local col = math.floor((ui.width - width) / 2) + term_cfg.left_padding

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

    vim.api.nvim_win_set_option(win, "cursorline", true)
    if term_cfg.number then
        vim.api.nvim_win_set_option(win, "number", true)
        if term_cfg.relativenumber then
            vim.api.nvim_win_set_option(win, "relativenumber", true)
        end
    end
    if term_cfg.scroll then
        vim.api.nvim_win_set_option(win, "scrolloff", 5)
    end

    vim.fn.termopen(cmd)
    vim.api.nvim_buf_set_keymap(buf, "n", M.close_key, "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
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
        vim.fn.mkdir(project_root, "p")
        vim.fn.mkdir(project_root .. "/tests", "p")

        write_file(project_root .. "/main.py", [[
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
]])

        -- Set up virtual environment
        vim.fn.system("python -m venv " .. project_root .. "/venv")

        write_file(project_root .. "/requirements.txt", "")
        write_file(project_root .. "/setup.py", string.format([[
from setuptools import setup, find_packages

setup(
    name="%s",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[],
    python_requires=">=3.6",
)
]], project_name))

        vim.cmd("edit " .. project_root .. "/main.py")
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
        if not file_name or file_name == "" then
            return print("File creation canceled.")
        end

        if not file_name:match("%.py$") then
            file_name = file_name .. ".py"
        end

        local root_dir = M.get_project_root()
        if not root_dir then
            return print("Error: Project root not found.")
        end

        local file_path = root_dir .. "/" .. file_name
        write_file(file_path, "")
    end)
end

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
        if vim.fn.isdirectory(dir .. "/venv") == 1 or vim.fn.filereadable(dir .. "/main.py") == 1 then
            return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
    end
    return nil
end

function M.run()
    local root = M.get_project_root()
    if not root then
        return print("Error: Project root not found.")
    end

    local main_file = root .. "/main.py"
    if vim.fn.filereadable(main_file) == 0 then
        return print("Error: main.py not found in project root.")
    end

    -- Check if virtual environment exists
    local venv_path = root .. "/venv/bin/activate"
    local venv_cmd = vim.fn.filereadable(venv_path) == 1 and "source " .. venv_path .. " && " or ""

    M.open_float_terminal(venv_cmd .. "python " .. main_file)
end

return M
