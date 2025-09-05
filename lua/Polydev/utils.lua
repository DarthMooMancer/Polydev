local M = {}
M.opts = {}

function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("terminal"), opts or {})
end

---@return string
function M.get_project_root()
	local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")

	local dir = vim.fn.system(plugin_dir .. "/bash_scripts/walkup.sh"):gsub("%s+$", "")
	return dir
end

---@return string
function M.get_project_name()
	return vim.fn.fnamemodify(M.get_project_root(), ":t")
end

---@param path_segments table
---@param content string
function M.write_file(path_segments, content)
	local path = table.concat(path_segments, "/")
	local file = assert(io.open(path, "w"), "Error creating file: " .. path)
	file:write(content)
	file:close()
	vim.cmd("edit " .. path)
end

---@param path string
---@param gitignore_lines table
function M.init_git(path, gitignore_lines)
	vim.fn.mkdir(path, "p")
	vim.fn.system({ "git", "-C", path, "init" })

	if gitignore_lines and #gitignore_lines > 0 then
		local contents = table.concat(gitignore_lines, "\n")
		M.write_file({ path, ".gitignore" }, contents)
	end
end

---@param cmd table
---@return integer, integer?
function M.terminal(cmd)
	if M.opts.mode == "floating" then
		local opts = require("Polydev.presets").getPresets(M.opts.win.anchor)

		local ui = vim.api.nvim_list_uis()[1]
		local width, height, row, col

		if opts ~= nil then
			width = math.max(1, math.floor(ui.width * 0.9) - opts.left - opts.right)
			height = math.max(1, math.floor(ui.height * 0.9) - opts.top - opts.bottom)
			row = math.floor((ui.height - height) / 2) + opts.top
			col = math.floor((ui.width - width) / 2) + opts.left
		end
		if opts == nil then
			width = math.max(1, math.floor(ui.width * 0.9))
			height = math.max(1, math.floor(ui.height * 0.9))
			row = math.floor((ui.height - height) / 2)
			col = math.floor((ui.width - width) / 2)
		end
		local buf = vim.api.nvim_create_buf(false, true)
		local win = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = width,
			height = height,
			row = row,
			col = col,
			style = "minimal",
			border = M.opts.border.enabled and M.opts.border.type,
		})
		vim.api.nvim_set_option_value("winhighlight", "Normal:PolydevNormal,FloatBorder:PolydevBorder", { win = win })
		vim.fn.jobstart(table.concat(cmd, "/"), { term = true })
		vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
		return buf, win
	end
	if M.opts.mode == "split" then
		if M.opts.win.type == "vertical" then
			if M.opts.win.anchor == "right" then
				vim.cmd("set splitright")
			end
		end
		if M.opts.win.type == "horizontal" then
			if M.opts.win.anchor == "bottom" then
				vim.cmd("set splitbelow")
			end
		end

		if M.opts.win.type == "vertical" then
			vim.cmd(M.opts.win.size .. " vsplit")
		end
		if M.opts.win.type == "horizontal" then
			vim.cmd(M.opts.win.size .. " split")
		end
		local buf = vim.api.nvim_create_buf(false, true)
		local win = vim.api.nvim_get_current_win()

		vim.api.nvim_win_set_buf(0, buf)

		vim.fn.jobstart(table.concat(cmd, "/"), { term = true })
		vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
		return buf, win
	end
	return 0
end

return M
