---@module "Polydev.presets"
local presets = require("Polydev.presets")

---@type table
local M = {}

---@type table
M.opts = {}

---@type table
local presets_opts = {}

---@param opts table
function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("terminal"), opts or {})
end

---@param path string
---@param content string
function M.write_file(path, content)
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
    print(path .. " created successfully!")
end

---@param cmd string
---@return boolean, table
function M.open_float_terminal(cmd)
    if presets.getPresets(M.opts.presets) ~= nil then
	presets_opts = presets.getPresets(M.opts.presets)
    end
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

    vim.api.nvim_win_set_option(win, "winblend", vim.o.pumblend)
    vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Pmenu,FloatBorder:Pmenu")
    vim.api.nvim_win_set_option(win, "cursorline", true)
    vim.api.nvim_win_set_option(win, "scrolloff", 5)
    if(M.opts.number == true) then
	vim.api.nvim_win_set_option(win, "number", true)
	if(M.opts.relativenumber == true) then
	    vim.api.nvim_win_set_option(win, "relativenumber", true)
	end
    end

    vim.fn.termopen(cmd)
    vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
    return buf, win
end

---@return table
return M
