---@type table
local M = {}

---@type table
local opts = {}

---@class Preset
---@field left_padding integer
---@field right_padding integer
---@field top_padding integer
---@field bottom_padding integer

---@type Preset
local center = {
    left_padding = 0,
    right_padding = 0,
    top_padding = 0,
    bottom_padding = 0
}

---@type Preset
local center_panel = {
    left_padding = 0,
    right_padding = 100,
    top_padding = 0,
    bottom_padding = 0,
}

---@type Preset
local right_panel = {
    left_padding = 100,
    right_padding = 0,
    top_padding = 0,
    bottom_padding = 0,
}

---@type Preset
local corner = {
    left_padding = 100,
    right_padding = 0,
    top_padding = 25,
    bottom_padding = 0,

}

---@param preset string
---@return table
function M.getPresets(preset)
	--    if preset == "custom" then
	-- opts = nil
    if preset == "centered" then
	opts = center
    elseif preset == "center_panel" then
	opts = center_panel
    elseif preset == "right_panel" then
	opts = right_panel
    elseif preset == "cornered" then
	opts = corner
    else
	print("Preset option: " .. preset .. " does not exist")
    end

    return opts
end

return M
