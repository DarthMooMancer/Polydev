local M = {}

function M.setup_highlights()
    local function define(name, opts)
	if vim.fn.hlexists(name) == 0 then
	    vim.api.nvim_set_hl(0, name, opts)
	end
    end

    define("PolydevNormal", {
	fg = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = true }).fg,
	bg = vim.api.nvim_get_hl(0, { name = "Normal", link = true }).bg,
    })

    define("PolydevBorder", {
	fg = vim.api.nvim_get_hl(0, { name = "Function", link = true }).fg,
	bg = vim.api.nvim_get_hl(0, { name = "Normal", link = true }).bg,
    })

    define("PolydevTitle",  {
	fg = vim.api.nvim_get_hl(0, { name = "FloatTitle", link = true }).fg, bold = true,
	bg = vim.api.nvim_get_hl(0, { name = "Normal", link = true }).bg,
    })
end

return M
