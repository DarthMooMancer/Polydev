---@type table
local M = {}

---@type table|nil
M.opts = nil

---@param opts table
function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("html"), opts or {})
end

---@return table
return M
