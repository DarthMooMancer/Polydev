local M = {}

---@class padding
---@field left_padding integer
---@field right_padding integer
---@field top_padding integer
---@field bottom_padding integer

---@class preset_list
---@field right padding
---@field corner padding

---@type preset_list
local presets = {
    right = {
	left_padding = 100,
	right_padding = 0,
	top_padding = 0,
	bottom_padding = 0,
    },
    corner = {
	left_padding = 100,
	right_padding = 0,
	top_padding = 25,
	bottom_padding = 0,
    }
}

---@param preset string
---@return table|nil
function M.getPresets(preset)
    return presets[preset]
end

return M
