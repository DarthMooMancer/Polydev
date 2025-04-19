---@type table
local M = {}

---@type table|nil
local opts = {}

---@class Preset
---@field left_padding integer
---@field right_padding integer
---@field top_padding integer
---@field bottom_padding integer

---@type Preset
local centered = {
    left_padding = 0,
    right_padding = 0,
    top_padding = 0,
    bottom_padding = 0
}

---@type Preset
local center_paneled = {
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
local cornered = {
    left_padding = 100,
    right_padding = 0,
    top_padding = 25,
    bottom_padding = 0,

}

---@param preset string
---@return table|nil
function M.getPresets(preset)
    if preset == "custom" then
	opts = nil
    elseif preset == "centered" then
	opts = centered
    elseif preset == "center_panel" then
	opts = center_paneled
    elseif preset == "right_panel" then
	opts = right_panel
    elseif preset == "cornered" then
	opts = cornered
    else
	print("Preset option: " .. preset .. " does not exist")
    end

    return opts
end

return M
