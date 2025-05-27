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
	table.insert(result, {
	    name = name .. (type == "directory" and "/" or ""),
	    type = type,
	    full_path = path .. "/" .. name,
	})
	end
	table.sort(result, function(a, b)
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

---@param project_root string
function M.manager(project_root)
    local templates = require("Polydev.templates")
    local Popup = require("nui.popup")
    local Layout = require("nui.layout")
    local cwd = vim.fn.expand(vim.fn.getcwd())
    local entries = get_entries(cwd)
    local current_view = vim.deepcopy(entries)

    local popup = Popup({
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
    })
    local layout = Layout(
	{
	    position = "50%",
	    size = { width = "80%", height = "90%" },
	},
	Layout.Box({ Layout.Box(popup, { grow = 1 }) }, { dir = "row" })
    )
    layout:mount()

    ---@return table, integer
    local function get_selected_entry()
	local row = vim.api.nvim_win_get_cursor(popup.winid)[1] - 1
	return current_view[row], row
    end


    ---@return string, string
    local function get_inputs()
	local l, n
	vim.ui.input({ prompt = "Enter language for new file: " }, function(lang)
	    vim.ui.input({ prompt = "Enter file name: " }, function(name)
		if not lang or lang == "" then return end
		if not name or name == "" then return end
		l, n = lang, name
	    end)
	end)
	return l, n
    end

    local function update_screen()
	entries = get_entries(cwd)
	local root = vim.fn.expand(project_root)

	if not cwd:find(root, 1, true) then
	    cwd = root
	    entries = get_entries(cwd)
	end

	if cwd ~= root then
	    table.insert(entries, 1, {
		name = "../",
		type = "directory",
		full_path = vim.fn.fnamemodify(cwd, ":h"),
		is_up = true
	    })
	end
	current_view = vim.deepcopy(entries)

	if not popup.bufnr then return end
	vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {})
	for i, item in ipairs(current_view) do
	    local line = string.format("%-2d | %-27s | %-6s", i, item.name, item.type)
	    vim.api.nvim_buf_set_lines(popup.bufnr, -1, -1, false, { line })
	end
    end

    popup:map("n", "<ESC>", function() popup:unmount() end)

    popup:map("n", "a", function()
	vim.ui.input({ prompt = "New folder name: " }, function(input)
	    if input then
		vim.fn.mkdir(cwd .. "/" .. input, "p")
		update_screen()
	    end
	end)
    end)

    popup:map("n", "R", function()
	local entry = get_selected_entry()
	if not entry.is_up then
	    vim.ui.input({ prompt = "Rename: ", default = entry.name }, function(input)
		if input then
		    local new_path = cwd .. "/" .. input
		    vim.fn.rename(entry.full_path, new_path)
		    update_screen()
		end
	    end)
	end
    end)

    popup:map("n", "<CR>", function()
	local entry = get_selected_entry()
	if entry.type == "directory" then
	    cwd = entry.full_path
	    vim.cmd("cd " .. cwd)
	    update_screen()
	end
	if entry.type == "file" then
	    popup:unmount()
	    vim.cmd("edit " .. vim.fn.fnameescape(entry.full_path))
	end
    end)

    popup:map("n", "D", function()
	local entry = get_selected_entry()
	if not entry.is_up then
	    vim.ui.input({ prompt = "Deletion of " .. entry.name .. ": (y/N) Defaults to N: " }, function(input)
		if input == "y" or input == "Y" then
		    vim.fn.delete(entry.full_path, "rf")
		    update_screen()
		end
	    end)
	end
    end)

    popup:map("n", "%", function()
	local lang, name = get_inputs()
	if lang == nil or lang == "" then return print("Error: Can't have a blank name for lang") end
	if templates.files[lang].run then
	    popup:unmount()
	    if name ~= nil and name ~= "" then
		templates.files[lang].run(name)
	    end
	else
	    print("Error: No File creation method for " .. lang)
	end
    end)

    popup:map("n", "x", function()
	local lang, name = get_inputs()
	if lang == nil or lang == "" then return print("Error: Can't have a blank name for lang") end
	if templates.extras.run then
	    popup:unmount()
	    if name ~= nil and name ~= "" then
		templates.extras.run(lang, name)
	    end
	else
	    print("Error: No File creation method for " .. lang)
	end
    end)

    popup:map("n", "d", function()
	local lang, name = get_inputs()
	local opts = {}
	opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get(lang), opts or {})
	if lang == nil or lang == "" then return print("Error: Can't have a blank name for lang") end
	if templates.projects[lang].run then
	    popup:unmount()
	    if name ~= nil and name ~= "" then
		templates.projects[lang].run(name, opts.project_root)
	    end
	else
	    print("Error: No project creation method for " .. lang)
	end
    end)

    popup:mount()
    update_screen()
end

return M
