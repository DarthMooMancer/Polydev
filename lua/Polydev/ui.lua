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
        if a.type == "directory" and b.type ~= "directory" then return true end
        if b.type == "directory" and a.type ~= "directory" then return false end
        return a.name < b.name
    end)
    return result
end

---@param project_root string
function M.manager(project_root)
    local ui = vim.api.nvim_list_uis()[1]
    local width, height = math.floor(ui.width * 0.8), math.floor(ui.height * 0.9)
    local row, col = math.floor((ui.height - height) / 2), math.floor((ui.width - width) / 2)
    local content_row = row + 2
    local content_height = height - 3

    local tabs = { "Projects", "Recents" }
    local selected = 1
    local selected_tab = tabs[selected]

    local cwd = vim.fn.getcwd()
    local current_view = {}

    local tab_buf = vim.api.nvim_create_buf(false, true)
    local tab_win = vim.api.nvim_open_win(tab_buf, false, {
        relative = "editor",
        width = width,
        height = 1,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    local content_bufs = {
        Projects = vim.api.nvim_create_buf(false, true),
        Recents = vim.api.nvim_create_buf(false, true),
    }

    local content_wins = {
        Projects = vim.api.nvim_open_win(content_bufs.Projects, true, {
            relative = "editor",
            width = width,
            height = content_height,
            row = content_row,
            col = col,
            style = "minimal",
            border = "rounded",
        }),
        Recents = nil,
    }

    local function update_tab_bar()
        local line = {}
        for i, tab in ipairs(tabs) do
            local label = (i == selected and "[ " .. tab .. " ]") or ("  " .. tab .. "  ")
            table.insert(line, label)
        end
        vim.api.nvim_buf_set_lines(tab_buf, 0, -1, false, { table.concat(line, " ") })
    end

    local function update_screen()
        if selected_tab == "Projects" then
            local entries = get_entries(cwd)
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
                    is_up = true,
                })
            end
            current_view = vim.deepcopy(entries)

            local lines = {}
            for i, item in ipairs(current_view) do
                table.insert(lines, string.format("%-2d | %-27s | %-6s", i, item.name, item.type))
            end
            vim.api.nvim_buf_set_lines(content_bufs.Projects, 0, -1, false, lines)

        elseif selected_tab == "Recents" then
            local oldfiles = vim.v.oldfiles
            local valid = {}
            for _, file in ipairs(oldfiles) do
                if vim.fn.filereadable(file) == 1 then
                    table.insert(valid, file)
                end
            end
            current_view = vim.tbl_map(function(f)
                return { name = vim.fn.fnamemodify(f, ":t"), full_path = f, type = "file" }
            end, valid)

            local lines = {}
            for i, item in ipairs(current_view) do
                table.insert(lines, string.format("%-2d | %-40s", i, item.full_path))
            end
            vim.api.nvim_buf_set_lines(content_bufs.Recents, 0, -1, false, lines)
        end
    end

    local function get_selected_entry()
        local win = content_wins[selected_tab]
        if not win or not vim.api.nvim_win_is_valid(win) then return end
        local row = vim.api.nvim_win_get_cursor(win)[1]
        return current_view[row], row
    end

    local function switch_tab(index)
        if content_wins[selected_tab] and vim.api.nvim_win_is_valid(content_wins[selected_tab]) then
            vim.api.nvim_win_hide(content_wins[selected_tab])
        end

        selected = ((index - 1) % #tabs) + 1
        selected_tab = tabs[selected]

        if not content_wins[selected_tab] or not vim.api.nvim_win_is_valid(content_wins[selected_tab]) then
            content_wins[selected_tab] = vim.api.nvim_open_win(content_bufs[selected_tab], true, {
                relative = "editor",
                width = width,
                height = content_height,
                row = content_row,
                col = col,
                style = "minimal",
                border = "rounded",
            })
        else
            vim.api.nvim_set_current_win(content_wins[selected_tab])
        end

        update_tab_bar()
        update_screen()
    end

    update_tab_bar()
    update_screen()

    -- Shared mappings
    for _, buf in pairs(content_bufs) do
        vim.keymap.set("n", "<Tab>", function() switch_tab(selected + 1) end, { buffer = buf })
        vim.keymap.set("n", "gT", function() switch_tab(selected - 1) end, { buffer = buf })
        vim.keymap.set("n", "<ESC>", function()
            for _, win in pairs(content_wins) do
                if win and vim.api.nvim_win_is_valid(win) then
                    pcall(vim.api.nvim_win_close, win, true)
                end
            end
            pcall(vim.api.nvim_win_close, tab_win, true)
        end, { buffer = buf })
    end

    -- Open file
    for tab, buf in pairs(content_bufs) do
	vim.keymap.set("n", "<CR>", function()
	    local entry = get_selected_entry()
	    if not entry then return end

	    if entry.type == "file" then
		for _, win in pairs(content_wins) do
		    if win and vim.api.nvim_win_is_valid(win) then
			pcall(vim.api.nvim_win_close, win, true)
		    end
		end
		pcall(vim.api.nvim_win_close, tab_win, true)
		vim.cmd("edit " .. vim.fn.fnameescape(entry.full_path))

	    elseif entry.type == "directory" then
		cwd = entry.full_path
		vim.cmd("cd " .. cwd)
		update_screen()
	    end
	end, { buffer = buf })

    end
end

return M
