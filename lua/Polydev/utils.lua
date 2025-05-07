local presets = require("Polydev.presets")

local M = {}

M.opts = {}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("terminal"), opts or {})
end

function M.is_dir(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

function M.write_file(path, content)
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
end

function M.open_float_terminal(cmd)
    local presets_opts = {}
    if presets.getPresets(M.opts.presets) == nil then return nil end
    presets_opts = presets.getPresets(M.opts.presets)
    local ui = vim.api.nvim_list_uis()[1]

    local width = math.max(1, math.floor(ui.width * 0.9) - presets_opts.left_padding - presets_opts.right_padding)
    local height = math.max(1, math.floor(ui.height * 0.9) - presets_opts.top_padding - presets_opts.bottom_padding)
    local row = math.max(1, math.floor((ui.height - height) / 2) + (presets_opts.top_padding))
    local col = math.max(1, math.floor((ui.width - width) / 2) + (presets_opts.left_padding))

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

    vim.fn.termopen(cmd)
    vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
    return buf, win
end

---@return table
return M
