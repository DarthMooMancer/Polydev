local M = {}

M.opts = {}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("html"), opts or {})
end

return M
