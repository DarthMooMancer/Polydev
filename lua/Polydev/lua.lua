local M = {}
M.close_key = nil
M.lua_run = nil
M.new_lua_file = nil

M.config = {
    project_root = "~/Projects/Lua",
    keybinds = {
        ["<Esc>"] = "CloseTerminal",
        ["<leader>pr"] = "LuaRun",
        ["<leader>nf"] = "NewLuaFile",
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

-- Function to get the project root directory
function M.get_project_root()
    -- You can modify this to be more sophisticated if needed
    -- This simply looks for a directory containing init.lua or any specific file
    local project_root = vim.fn.expand(M.config.project_root)
    return project_root
end

-- Function to setup the configuration
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    for key, command in pairs(M.config.keybinds) do
        if command == "CloseTerminal" then M.close_key = key end
        if command == "LuaRun" then M.lua_run = key end
        if command == "NewLuaFile" then M.new_lua_file = key end
    end

    -- Define user commands and key mappings
    vim.api.nvim_create_user_command("NewLuaFile", M.create_new_file, {})
    vim.api.nvim_create_user_command("LuaRun", M.run, {})

    vim.keymap.set("n", M.lua_run, ":LuaRun<CR>", { silent = true })
    vim.keymap.set("n", M.new_lua_file, ":NewLuaFile<CR>", { silent = true })
end

-- Function to open a floating terminal with command
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
    return buf, win
end

-- Function to write content to a file
local function write_file(path, content)
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
    print(path .. " created successfully!")
end

-- Function to create a new project with the required directories
function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
        if not project_name or project_name == "" then
            print("Project creation canceled.")
            return
        end

        local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
        -- Create the required directory structure
        for _, path in ipairs({ "/lua/" .. project_name }) do
            vim.fn.mkdir(project_root .. path, "p")
        end

        -- Create a sample init.lua
        write_file(project_root .. "/lua/" .. project_name .. "/init.lua", [[
local M = {}
return M
]])

        vim.cmd("edit " .. project_root .. "/lua/" .. project_name .. "/init.lua")
    end)
end

-- Function to create a new Lua file
function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(class_name)
        if not class_name or class_name == "" then return print("File creation canceled.") end
        local root_dir = M.get_project_root()
        if not root_dir then return print("Error: Project root not found.") end
        write_file(root_dir .. "/lua/" .. M.get_project_name() .. "/" .. class_name .. ".lua", "")
    end)
end

-- Function to run the init.lua file from /lua/<project_name>/init.lua
function M.run()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end

    -- Define the path to the init.lua
    local init_path = root .. "/lua/" .. M.get_project_name() .. "/init.lua"

    -- Check if the init.lua file exists
    if vim.fn.filereadable(init_path) == 1 then
        M.open_float_terminal("lua " .. init_path)
    else
        print("Error: init.lua not found in " .. init_path)
    end
end

return M

