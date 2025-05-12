local M = {}

function M.setup(user_opts)
    local opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("html"), user_opts or {})
end

return M
