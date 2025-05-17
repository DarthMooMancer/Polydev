local M = {}

---@param path string
---@return table
local function get_entries(path)
    local result = {}
    local handle = vim.uv.fs_scandir(path)
    if not handle then return result end
    while true do
	local name, type = vim.uv.fs_scandir_next(handle)
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

---@param list table
---@param query string
---@return table
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

---@param project_root string
function M.manager(project_root)
    local templates = require("Polydev.templates")
    local languages = require("Polydev.languages")
    local Popup = require("nui.popup")
    local Layout = require("nui.layout")
    local event = require("nui.utils.autocmd").event
    local cwd = vim.fn.expand(vim.fn.getcwd())
    local entries = get_entries(cwd)
    local current_view = vim.deepcopy(entries)

    -- Create a new custom highlight group with Normal background and NormalFloat foreground
	--    vim.api.nvim_set_hl(0, "PolydevNormal", {
	-- fg = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = true }).fg,
	-- bg = vim.api.nvim_get_hl(0, { name = "Normal", link = true }).bg,
	--    })

    local popup, search, preview = Popup({
	enter = true,
	focusable = true,
	border = {
	    style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid".
	    text = { top = " Results ", top_align = "center" },
	},
	position = "50%",
	buf_options = { modifiable = true, readonly = false },
	win_options = {
	    winhighlight = "Normal:PolydevNormal,FloatBorder:PolydevBorder,FloatTitle:PolydevTitle",
	}
    }), Popup({
	enter = false,
	focusable = true,
	border = {
	    style = "rounded", -- "rounded", "single" or "solid".
	    text = { top = " Find Files ", top_align = "center" },
	},
	buf_options = { modifiable = true, readonly = false },
	win_options = {
	    winhighlight = "Normal:PolydevNormal,FloatBorder:PolydevBorder,FloatTitle:PolydevTitle",
	}
    }), Popup({
	enter = false,
	focusable = false,
	border = {
	    style = "rounded",
	    text = { top = " Grep Preview ", top_align = "center" },
	},
	position = "50%",
	buf_options = { modifiable = true, readonly = false },
	win_options = {
	    winhighlight = "Normal:PolydevNormal,FloatBorder:PolydevBorder,FloatTitle:PolydevTitle",
	}
    })
    local layout = Layout({
	position = "55%",
	size = { width = "81%", height = "90%" },
    },
	Layout.Box({
	    Layout.Box({
		Layout.Box(search, { size = "10%" }),
		Layout.Box(popup, { size = "93%" }),
	    }, { dir = "col", size = "48%" }),
	    Layout.Box(preview, { size = "51.5%" }),
	}, { dir = "row" })
    )
    layout:mount()

    local function get_selected_entry()
	local row = vim.api.nvim_win_get_cursor(popup.winid)[1] - 1
	return current_view[row], row
    end

    local function update_preview()
	if not preview.bufnr then return end
	vim.api.nvim_buf_set_lines(preview.bufnr, 0, -1, false, {}) -- Clear

	local entry = get_selected_entry()
	if not entry then return end

	if entry.type == "file" or entry.type == "project" then
	    -- Preview file contents (first 100 lines)
	    local lines = {}
	    local fd = io.open(entry.full_path, "r")
	    if fd then
		for i = 1, 100 do
		    local line = fd:read("*line")
		    if not line then break end
		    table.insert(lines, line)
		end
		fd:close()
	    else
		table.insert(lines, "[Failed to read file]")
	    end
	    vim.api.nvim_buf_set_lines(preview.bufnr, 0, -1, false, lines)
	elseif entry.type == "directory" then
	    -- List contents of directory
	    local contents = get_entries(entry.full_path)
	    local lines = {}
	    for _, item in ipairs(contents) do
		table.insert(lines, string.format("- %s", item.name))
	    end
	    if #lines == 0 then
		table.insert(lines, "[Empty folder]")
	    end
	    vim.api.nvim_buf_set_lines(preview.bufnr, 0, -1, false, lines)
	end
    end

    vim.api.nvim_create_autocmd("CursorMoved", {
	buffer = popup.bufnr,
	callback = function()
	    vim.schedule(update_preview)
	end,
    })

    local function refresh()
	entries = get_entries(cwd)
	local root = vim.fn.expand(project_root)

	-- If we're not in the Projects folder, redirect to Projects
	if not cwd:find(root, 1, true) then
	    cwd = root
	    entries = get_entries(cwd)
	end

	-- Only add ".." if we're inside Projects and not at the root
	if cwd ~= root then
	    table.insert(entries, 1, {
		name = "../",
		type = "directory",
		full_path = vim.fn.fnamemodify(cwd, ":h"),
		is_up = true
	    })
	end
	current_view = vim.deepcopy(entries)
    end

    local function render()
	local hints = {
	    "",
	    "/ → Find   a → New Directory   % → New File   R → Rename",
	    "x → New Helper File   d → New Project   D → Delete",
	}
	if not popup.bufnr then return end
	vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {})
	for i, item in ipairs(current_view) do
	    local line = string.format("%-2d | %-27s | %-6s", i, item.name, item.type)
	    vim.api.nvim_buf_set_lines(popup.bufnr, -1, -1, false, { line })
	end
	vim.api.nvim_buf_set_lines(popup.bufnr, -1, -1, false, hints)

	update_preview()
    end

    local function prompt_filter()
	vim.api.nvim_buf_set_lines(search.bufnr, 0, -1, false, { "" })
	vim.api.nvim_set_option_value("modifiable", true, { win = search.bufnr })
	if vim.api.nvim_win_is_valid(search.winid) then
	    vim.api.nvim_set_current_win(search.winid)
	end
	vim.cmd("startinsert")

	vim.keymap.set("i", "<CR>", function()
	    local input = vim.api.nvim_buf_get_lines(search.bufnr, 0, 1, false)[1]
	    if input ~= "" then
		current_view = fuzzy_filter(entries, input)
		render()
	    end
	    vim.api.nvim_buf_set_lines(search.bufnr, 0, -1, false, { "" })
	    vim.api.nvim_set_current_win(popup.winid)
	    vim.cmd("stopinsert")  -- exit insert mode
	end, { buffer = search.bufnr, noremap = true })

	vim.keymap.set("i", "<Esc>", function()
	    vim.api.nvim_set_current_win(popup.winid)
	    vim.cmd("stopinsert") -- ensure we are in normal mode
	end, { buffer = search.bufnr, noremap = true })
    end

    popup:map("n", "/", function() vim.schedule(prompt_filter) end)

    -- Mappings
    popup:map("n", "<ESC>", function() popup:unmount() end)

    -- Creates new file
    popup:map("n", "%", function()
	vim.ui.input({ prompt = "Enter language for new file: " }, function(lang)
	    if not lang or lang == "" then return print("File creation canceled") end
	    if languages.load_language_module(lang) and templates.files[lang] and templates.files[lang].run then
		popup:unmount()
		vim.schedule(function()
		    vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
			if not file_name or file_name == "" then return print("File creation canceled") end
			templates.files[lang].run(file_name)
		    end)
		end)
	    else
		print("Error: No File creation method for " .. lang)
	    end
	end)
    end)

    -- Creates extra file
    popup:map("n", "x", function()
	vim.ui.input({ prompt = "Enter language for new auxilary file: "}, function(lang)
	    if not lang or lang == "" then return print("File create canceled") end
	    if languages.load_language_module(lang) and templates.extras.run then
		popup:unmount()
		vim.schedule(function()
		    vim.ui.input({ prompt = "Enter file name: "}, function(file_name)
			if not file_name or file_name == "" then return print("File creation canceled") end
			templates.extras.run(lang, file_name)
		    end)
		end)
	    else
		print("Error: No File creation method for " .. lang)
	    end
	end)
    end)

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

    -- Creates new project
    popup:map("n", "d", function()
	local opts = {}
	vim.ui.input({ prompt = "Enter language for project: " }, function(lang)
	    if not lang or lang == "" then return print("Project creation canceled") end
	    opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get(lang), opts or {})
	    if languages.load_language_module(lang) and templates.projects[lang] and templates.projects[lang].run then
	    -- if templates.projects[lang] and templates.projects[lang].run then
		popup:unmount()
		vim.schedule(function()
		    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
			if not project_name or project_name == "" then return print("Project creation canceled") end
			templates.projects[lang].run(project_name, opts.project_root)
		    end)
		end)
	    else
		print("Error: No project creation method for " .. lang)
	    end
	end)
    end)

    -- Deletes Folder and confirms deletion
    popup:map("n", "D", function()
	local entry = get_selected_entry()
	if not entry.is_up then
	    vim.ui.input({ prompt = "Deletion of " .. entry.name .. ": (y/N) Defaults to N: " }, function(input)
		if input == "y" or input == "Y" then
		    vim.fn.delete(entry.full_path, "rf")
		    refresh()
		    render()
		end
	    end)
	end
    end)

    -- Renames Files and Folders
    popup:map("n", "R", function()
	local entry = get_selected_entry()
	if not entry.is_up then
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
	if entry.type == "directory" then
	    cwd = entry.full_path
	    vim.cmd("cd " .. cwd)
	    refresh()
	    render()
	end
	if entry.type == "file" then
	    popup:unmount()
	    vim.schedule(function()
		vim.cmd("edit " .. vim.fn.fnameescape(entry.full_path))
	    end)
	end
    end)

    popup:map("n", "<BS>", function()
	local parent = vim.fn.fnamemodify(cwd, ":h")
	if parent ~= cwd then
	    cwd = parent
	    refresh()
	    render()
	end
    end)

    popup:on(event.BufLeave, function()
	vim.defer_fn(function()
	    local function is_valid_win(winid)
		return type(winid) == "number" and vim.api.nvim_win_is_valid(winid)
	    end

	    if not is_valid_win(popup.winid) and not is_valid_win(search.winid) then
		popup:unmount()
	    end
	end, 50)
    end)

    popup:mount()
    refresh()
    render()
end

return M
