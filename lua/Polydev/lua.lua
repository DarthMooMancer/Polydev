local M = {}
M.close_key = nil
M.lua_run = nil

M.config = {
    project_root = "~/Projects/Lua",
    keybinds = {
        ["<Esc>"] = "CloseTerminal",
        ["<leader>pr"] = "LuaRun",
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

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
        local polydev_file = vim.fn.glob(dir .. "/*.polydev")
        if polydev_file ~= "" then return dir end
        dir = vim.fn.fnamemodify(dir, ":h")
    end
    return nil
end

function M.get_project_name()
    local root = M.get_project_root()
    if not root then return nil end
    local polydev_file = vim.fn.glob(root .. "/*.polydev")
    return polydev_file:match("([^/]+)%.polydev$")
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    for key, command in pairs(M.config.keybinds) do
        if command == "CloseTerminal" then M.close_key = key end
        if command == "LuaRun" then M.lua_run = key end
    end

    vim.api.nvim_create_user_command("LuaRun", M.run, {})
    vim.keymap.set("n", M.lua_run, ":LuaRun<CR>", { silent = true })
end

function M.open_float_terminal(cmd)
    local ui = vim.api.nvim_list_uis()[1]
    local term_cfg = M.config.terminal

    local width = math.max(1, math.floor(ui.width * 0.9) - term_cfg.left_padding - term_cfg.right_padding)
    local height = math.max(1, math.floor(ui.height * 0.9) - term_cfg.top_padding - term_cfg.bottom_padding)
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
        for _, path in ipairs({ "/lua/" .. project_name }) do vim.fn.mkdir(project_root .. path, "p") end

        write_file(project_root .. "/lua/" .. project_name .. "/init.lua", [[
local M = {}

return M
]])

        write_file(project_root .. "/" .. project_name .. ".polydev", "")
        vim.cmd("edit " .. project_root .. "/lua/" .. project_name .. "/init.lua")
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(class_name)
        if not class_name or class_name == "" then return print("File creation canceled.") end
        local root_dir = M.get_project_root()
        local project_name = M.get_project_name()
        if not root_dir or not project_name then return print("Error: Project root not found.") end
        write_file(root_dir .. "/lua/" .. project_name .. "/" .. class_name .. ".lua", "")
    end)
end

function M.run()
    local root = M.get_project_root()
    local project_name = M.get_project_name()
    if not root or not project_name then return print("Error: Project root not found.") end
    local init_lua_path = root .. "/lua/" .. project_name .. "/init.lua"
    if vim.fn.filereadable(init_lua_path) == 1 then
        M.open_float_terminal("lua " .. init_lua_path)
    else
        print("Error: " .. init_lua_path .. " not found in " .. root)
    end
end

return M

