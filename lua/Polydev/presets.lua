local M = {}

local presets = {
    right = {
	left   = 100,
	right  = 0,
	top    = 0,
	bottom = 0,
    },
    corner = {
	left   = 100,
	right  = 0,
	top    = 25,
	bottom = 0,
    }
}

---@param preset string
---@return table|nil
function M.getPresets(preset)
    if presets[preset] then
	return presets[preset]
    end
end

return M
