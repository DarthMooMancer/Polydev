local M = {}

local presets = {
    max = {
	left_padding = 0,
	right_padding = 0,
	top_padding = 0,
	bottom_padding = 0
    },
    center = {
	left_padding = 0,
	right_padding = 100,
	top_padding = 0,
	bottom_padding = 0,
    },
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

function M.getPresets(preset)
    if preset == "max" then
	return presets.centered
    elseif preset == "center" then
	return presets.center_panel
    elseif preset == "right" then
	return presets.right_panel
    elseif preset == "corner" then
	return presets.cornered
    elseif preset == nil then
	print("Preset returns nil value")
    else
	print("Preset option: " .. preset .. " does not exist")
    end
end

return M
