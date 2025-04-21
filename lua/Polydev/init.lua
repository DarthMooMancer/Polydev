local config = require("Polydev.configs")
local utils = require("Polydev.utils")
local templates = require("Polydev.templates")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local Path = require("plenary.path")

---@type table
local M = {}

---@type table
M.loaded_languages = {}

---@param lang string
---@param opts table?
---@return boolean
function M.load_language_module(lang, opts)
    if M.loaded_languages[lang] then return true end

    local ok, lang_module = pcall(require, "Polydev.languages." .. lang)
    if ok and lang_module.setup then
	local lang_opts = opts and opts[lang] or {}
	lang_module.setup(lang_opts)
	M.loaded_languages[lang] = lang_module
	return true
    end
    return false
end

-- Get entries in a given path
local function get_entries(path)
    local result = {}
    local handle = vim.loop.fs_scandir(path)
    if not handle then return result end
    while true do
	local name, type = vim.loop.fs_scandir_next(handle)
	if not name then break end
	-- Check if this is a project file
	local is_project = false
	if type == "file" then
	    local ext = name:match("%.([^%.]+)$")
	    if ext == "project" then
		is_project = true
		type = "project"
	    end
	end
	table.insert(result, {
	    name = name .. (type == "directory" and "/" or ""),
	    type = type,
	    full_path = path .. "/" .. name,
	    is_project = is_project
	})
    end
    table.sort(result, function(a, b) 
	-- Sort projects first, then directories, then files
	if a.is_project ~= b.is_project then
	    return a.is_project
	end
	if a.type == "directory" and b.type ~= "directory" then
	    return true
	end
	if b.type == "directory" and a.type ~= "directory" then
	    return false
	end
	return a.name < b.name
    end)
    return result
end

-- Fuzzy search
local function fuzzy_filter(list, query)
    local result = {}
    query = query:lower()
    for _, entry in ipairs(list) do
	if entry.name:lower():find(query) then
	    table.insert(result, entry)
	end
    end
    return result
end

-- Main function
local function open_filtered_table()
    local display_dir = vim.fn.expand(vim.fn.getcwd())
    local cwd = display_dir
    local entries = get_entries(cwd)
    local current_view = vim.deepcopy(entries)

    local popup = Popup({
	enter = true,
	focusable = true,
	border = {
	    style = "rounded",
	    text = { top = " Project Manager ", top_align = "center" },
	    highlight = "Normal",
	},
	position = "50%",
	size = { width = 60, height = 14 },
	buf_options = { modifiable = true, readonly = false },
    })

    local function get_selected_entry()
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	return current_view[row], row
    end

    local function refresh()
	entries = get_entries(cwd)
	local root = vim.fn.expand("~/Projects")
	if cwd ~= root then
	    table.insert(entries, 1, {
		name = "../",
		type = "directory",
		full_path = Path:new(cwd):parent():absolute(),
		is_up = true
	    })
	end
	current_view = vim.deepcopy(entries)
    end

    local function render()
	if not popup.bufnr then return end
	vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {})
	for i, item in ipairs(current_view) do
	    local line = string.format("%-3d | %-30s | %-6s", i, item.name, item.type)
	    vim.api.nvim_buf_set_lines(popup.bufnr, -1, -1, false, { line })
	end

	-- Add key mappings legend
	local hints = {
	    "",
	    "Keybinds:",
	    "  <CR>     : Open file / Enter directory",
	    "  <BS>     : Go to parent directory",
	    "  /        : Filter (fuzzy search)",
	    "  a        : Create new folder",
	    "  %        : Create new file",
	    "  d        : Create new project",
	    "  R        : Rename file/folder",
	    "  D        : Delete file/folder",
	    "  q        : Quit popup",
	}

	vim.api.nvim_buf_set_lines(popup.bufnr, -1, -1, false, hints)
    end

    local function prompt_filter()
	vim.ui.input({ prompt = "Search: " }, function(input)
	    if input then
		current_view = fuzzy_filter(entries, input)
		render()
	    end
	end)
    end

    -- Mappings
    popup:map("n", "q", function() popup:unmount() end)
    popup:map("n", "/", prompt_filter)

    -- Creates a new folder
    popup:map("n", "a", function()
	vim.ui.input({ prompt = "New folder name:" }, function(input)
	    if input then
		vim.fn.mkdir(cwd .. "/" .. input, "p")
		refresh()
		render()
	    end
	end)
    end)

    -- Deletes Folder and confirms deletion
    popup:map("n", "D", function()
	local entry = get_selected_entry()
	if entry and not entry.is_up then
	    vim.ui.input({ prompt = "(y/N) Defaults to N: " .. entry.name }, function(input)
		if input == "y" or input == "Y" then
		    vim.fn.delete(entry.full_path, "rf")
		    refresh()
		    render()
		end
	    end)
	end
    end)

    -- Creates a new file in project
    popup:map("n", "%", function()
	vim.ui.input({ prompt = "Enter language for new file: " }, function(lang)
	    if not lang or lang == "" then return print("File creation canceled.") end

	    if M.load_language_module(lang) and templates.files[lang] and templates.files[lang].run then
		vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
		    if not file_name or file_name == "" then return print("File creation canceled.") end
		    templates.files[lang].run(file_name)
		    refresh()
		    render()
		end)
	    else
		print("Error: No File creation method for " .. lang)
	    end
	end)
    end)

    -- Creates a new project
    popup:map("n", "d", function()
	local opts = {}
	vim.ui.input({ prompt = "Enter language for project: " }, function(lang)
	    if not lang or lang == "" then return print("Project creation canceled.") end
	    opts = vim.tbl_deep_extend("force", {}, config.get(lang), opts or {})
	    if M.load_language_module(lang) and templates.projects[lang] and templates.projects[lang].run then
		templates.create_project(lang, opts.project_root)
		vim.cmd("cd " .. templates.dir .. "/src")
		refresh()
		render()
	    else
		print("Error: No project creation method for " .. lang)
	    end
	end)
    end)

    -- Renames Files and Folders
    popup:map("n", "R", function()
	local entry = get_selected_entry()
	if entry and not entry.is_up then
	    vim.ui.input({ prompt = "Rename:", default = entry.name }, function(input)
		if input then
		    local new_path = cwd .. "/" .. input
		    vim.fn.rename(entry.full_path, new_path)
		    refresh()
		    render()
		end
	    end)
	end
    end)

    -- Changes working directory or edits a file
    popup:map("n", "<CR>", function()
	local entry = get_selected_entry()
	if entry and entry.type == "directory" then
	    cwd = entry.full_path
	    vim.cmd("cd " .. cwd)
	    refresh()
	    render()
	end
	if entry and entry.type == "file" then
	    vim.cmd("edit " .. entry.name)
	end
    end)

    popup:map("n", "<BS>", function()
	local parent = Path:new(cwd):parent():absolute()
	if parent ~= cwd then
	    cwd = parent
	    refresh()
	    render()
	end
    end)

    popup:on(event.BufLeave, function() popup:unmount() end)

    popup:mount()
    refresh()
    render()
end

---@param opts table
function M.setup(opts)
    opts = opts or {}
    config.setup(opts)
    utils.setup(opts)
    for lang, user_opts in pairs(opts) do
	local default = config.defaults[lang] or {}
	config.user_config[lang] = vim.tbl_deep_extend("force", default, user_opts)
    end

    vim.api.nvim_create_user_command("OpenSmartTable", open_filtered_table, {})
    vim.keymap.set("n", "<leader>po", ":OpenSmartTable<CR>", { silent = true })
    vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	    local filetype = vim.bo.filetype
	    M.load_language_module(filetype, opts)
	end,
    })
end

---@return table
return M
