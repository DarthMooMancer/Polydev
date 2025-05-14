local M = {}

local presets = {
    max = {
	left_padding = 0,
	right_padding = 0,
	top_padding = 0,
	bottom_padding = 0
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
	return presets.max
    elseif preset == "right" then
	return presets.right
    elseif preset == "corner" then
	return presets.corner
    else
	print("Preset option: " .. preset .. " does not exist")
    end
end

return M
