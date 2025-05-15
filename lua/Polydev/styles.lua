local M = {}

function M.setup_highlights()
    -- Only set if not already defined by colorscheme
    local function define(name, opts)
	if vim.fn.hlexists(name) == 0 then
	    vim.api.nvim_set_hl(0, name, opts)
	end
    end

    define("PolydevNormal", {
	fg = vim.api.nvim_get_hl_by_name("NormalFloat", true).foreground,
	bg = vim.api.nvim_get_hl_by_name("Normal", true).background
    })

    define("PolydevBorder", {
	fg = vim.api.nvim_get_hl_by_name("Function", true).foreground,
	bg = vim.api.nvim_get_hl_by_name("Normal", true).background
    })
    define("PolydevTitle",  { fg = "#89dceb", bold = true })
end

return M
