-- Get absolute path to this Lua file (or any file in your plugin)
local plugin_path = debug.getinfo(1, "S").source:sub(2)
local plugin_dir = vim.fn.fnamemodify(plugin_path, ":h")

-- Build the full path to your script
local script_path = plugin_dir .. "/bash_scripts/walkup.sh"

-- Run the script and get output
local dir = vim.fn.system(script_path):gsub("%s+$", "")
