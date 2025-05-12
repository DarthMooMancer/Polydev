local M = {}

M.opts = {}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("terminal"), opts or {})
end

function M.is_dir(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "directory"
end

function M.get_project_root()
    local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")

    local dir = vim.fn.system(plugin_dir .. "/bash_scripts/walkup.sh"):gsub("%s+$", "")
    return dir
end

function M.get_project_name()
    local root = M.get_project_root()
    return vim.fn.fnamemodify(root, ":t")
end

function M.write_file(path_segments, content)
    local path = table.concat(path_segments, "/")
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
end

function M.init_git(path, gitignore_lines)
    vim.fn.mkdir(path, "p")
    vim.fn.system({ "git", "-C", path, "init" })

    if gitignore_lines and #gitignore_lines > 0 then
        local gitignore_path = { path, ".gitignore" }
        local contents = table.concat(gitignore_lines, "\n")
        M.write_file(gitignore_path, contents)
    end
end

---@param cmd table
function M.open_float_terminal(cmd)
    local presets = require("Polydev.presets")
    local presets_opts = presets.getPresets(M.opts.preset)
    local ui = vim.api.nvim_list_uis()[1]

    local width = math.max(1, math.floor(ui.width * 0.9) - presets_opts.left_padding - presets_opts.right_padding)
    local height = math.max(1, math.floor(ui.height * 0.9) - presets_opts.top_padding - presets_opts.bottom_padding)
    local row = math.floor((ui.height - height) / 2) + presets_opts.top_padding
    local col = math.floor((ui.width - width) / 2) + presets_opts.left_padding

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
	relative = "editor",
	width = width,
	height = height,
	row = row,
	col = col,
	style = "minimal",
	border = M.opts.border and "rounded" or "none",
    })
    vim.api.nvim_set_option_value("winblend", vim.o.pumblend, { win = win })
    vim.api.nvim_set_option_value("winhighlight", "Normal:Pmenu,FloatBorder:Pmenu", { win = win })
    vim.api.nvim_set_option_value("cursorline", true, { win = win })
    vim.api.nvim_set_option_value("scrolloff", 5, { win = win })
    if(M.opts.number) then
	vim.api.nvim_set_option_value("number", true, { win = win })
	if(M.opts.relativenumber) then
	    vim.api.nvim_set_option_value("relativenumber", true, { win = win })
	end
    end

    vim.fn.termopen(table.concat(cmd, "/"))
    vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
    return buf, win
end

return M
