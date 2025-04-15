local config = require("Polydev.configs")
local M = {}

M.opts = {}

function M.setup(opts)
    -- Get the terminal options from the config (either user-config or defaults)
    local terminal_opts = config.get("terminal")

    -- If no user options are passed in, merge them with the defaults from config
    M.opts = vim.tbl_deep_extend("force", {}, terminal_opts, opts or {})
end

function M.write_file(path, content)
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
    print(path .. " created successfully!")
end

function M.open_float_terminal(cmd)
    if not M.opts.number then
	print("Number is false")
    end

    if M.opts.number then
	print("Number is true")
    end
        -- Ensure M.opts is correctly set before accessing
    if not M.opts.left_padding then
        print("Error: Terminal padding options are missing.")
        return
    end

    local ui = vim.api.nvim_list_uis()[1]

    local width = math.max(1, math.floor(ui.width * 0.9) - M.opts.left_padding or 0 - M.opts.right_padding or 0)
    local height = math.max(1, math.floor(ui.height * 0.9) - M.opts.top_padding or 0 - M.opts.bottom_padding or 0)
    local row = math.max(1, math.floor((ui.height - height) / 2) + (M.opts.top_padding or 0))
    local col = math.max(1, math.floor((ui.width - width) / 2) + (M.opts.left_padding or 0))

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
    if(M.opts.number == true) then
	vim.api.nvim_win_set_option(win, "number", true)
	if(M.opts.relativenumber == true) then
	    vim.api.nvim_win_set_option(win, "relativenumber", true)
	end
    end
    if(M.opts.scroll == true) then
	vim.api.nvim_win_set_option(win, "scrolloff", 5)
    end

    vim.fn.termopen(cmd)
    vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
    return buf, win
end

return M
