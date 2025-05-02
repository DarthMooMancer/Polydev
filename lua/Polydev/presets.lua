local M = {}

local opts = {}

M.presets = {
    centered = {
	left_padding = 0,
	right_padding = 0,
	top_padding = 0,
	bottom_padding = 0
    },
    center_panel = {
	left_padding = 0,
	right_padding = 100,
	top_padding = 0,
	bottom_padding = 0,
    },
    right_panel = {
	left_padding = 100,
	right_padding = 0,
	top_padding = 0,
	bottom_padding = 0,
    },
    cornered = {
	left_padding = 100,
	right_padding = 0,
	top_padding = 25,
	bottom_padding = 0,
    }
}

function M.getPresets(preset)
    if preset == "centered" then
	opts = M.presets.centered
    elseif preset == "center_panel" then
	opts = M.presets.center_panel
    elseif preset == "right_panel" then
	opts = M.presets.right_panel
    elseif preset == "cornered" then
	opts = M.presets.cornered
    else
	print("Preset option: " .. preset .. " does not exist")
    end

    return opts
end

return M
