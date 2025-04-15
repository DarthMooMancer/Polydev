local M = {}
local utils = require("Polydev.utils")

M.c_build = nil
M.c_run = nil
M.new_c_header_file = nil

M.config = {
    project_root = "~/Projects/C",
    keybinds = {
	["<leader>pb"] = "CBuild",
	["<leader>pr"] = "CRun",
	["<leader>nh"] = "NewCHeaderFile",
    },
    build_attributes = ""
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    for key, command in pairs(M.config.keybinds) do
	if command == "CBuild" then M.c_build = key end
	if command == "CRun" then M.c_run = key end
	if command == "NewCHeaderFile" then M.new_c_header_file = key end
    end

    vim.api.nvim_create_user_command("NewCHeaderFile", M.create_new_header_file, {})
    vim.api.nvim_create_user_command("CBuild", M.build, {})
    vim.api.nvim_create_user_command("CRun", M.run, {})

    vim.keymap.set("n", M.c_build, ":CBuild<CR>", { silent = true })
    vim.keymap.set("n", M.c_run, ":CRun<CR>", { silent = true })
    vim.keymap.set("n", M.new_c_header_file, ":NewCHeaderFile<CR>", { silent = true })
end


function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then
	    print("Project creation canceled.")
	    return
	end

	local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
	for _, path in ipairs({ "/src", "/build", "/include" }) do
	    vim.fn.mkdir(project_root .. path, "p")
	end

	utils.write_file(project_root .. "/build/" .. project_name .. ".polydev", project_name)
	utils.write_file(project_root .. "/src/main.c", [[
/* If you have vcpkg and want to use it:
vcpkg new --application
vcpkg add port <package_name>
*/

#include <stdio.h>

int main() {
  printf("%s", "Hello World");
  return 0;
}
]])

	utils.write_file(project_root .. "/CMakeLists.txt", string.format([[
cmake_minimum_required(VERSION 3.10)
project(%s)
include_directories(include)
set(SOURCES src/main.c)
add_executable(%s ${SOURCES})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)

# find_package(SDL3 CONFIG REQUIRED) # An example of how to import libraries from vcpkg
# target_link_libraries(Game PRIVATE SDL3::SDL3)
]], project_name, project_name))


	utils.write_file(project_root .. "/CMakePresets.json", string.format([[
# For the purposes of vcpkg, DO NOT REMOVE, but feel free to change as needed
{
  "version": 2,
  "configurePresets": [
    {
      "name": "vcpkg",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
      }
    }
  ]
}
]]))

	utils.write_file(project_root .. "/CMakeUserPresets.json", string.format([[
{
  "version": 2,
  "configurePresets": [
    {
      "name": "default",
      "inherits": "vcpkg",
      "environment": {
        "VCPKG_ROOT": "/Users/<USER>/vcpkg"
      }
    }
  ]
}

]]))
	vim.cmd("edit " .. project_root .. "/src/main.c")
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(class_name)
	if not class_name or class_name == "" then return print("File creation canceled.") end
	local root_dir = M.get_project_root()
	if not root_dir then return print("Error: Project root not found.") end
	utils.write_file(root_dir .. "/src/" .. class_name .. ".c", "")
    end)
end

function M.create_new_header_file()
    vim.ui.input({ prompt = "Enter header file name: " }, function(header_name)
	if not header_name then return print("Header file creation canceled.") end
	local root_dir = M.get_project_root()
	if not root_dir then return print("Error: Project root not found.") end
	local guard_macro = header_name:upper():gsub("[^A-Z0-9]", "_") .. "_H"
	local content = string.format([[
#ifndef %s
#define %s

#include <stdio.h>

// Function prototypes
void example_function();

#endif // %s
]], guard_macro, guard_macro, guard_macro)
	utils.write_file(root_dir .. "/include/" .. header_name .. ".h", content)
    end)
end

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
	if vim.fn.isdirectory(dir .. "/src") == 1 or vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1 then
	    return dir
	end
	dir = vim.fn.fnamemodify(dir, ":h")
    end
end

function M.build()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end
    local build_dir = root .. "/build"

    local cmd = "cd " .. build_dir .. " && cmake --build ."
    local term_buf = utils.open_float_terminal(cmd)
    vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
    local output = vim.fn.system(cmd)
    local success = vim.v.shell_error == 0
    vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, vim.list_extend({ success and "Compilation successful!" or "Error during compilation:" }, vim.split(output, "\n", { trimempty = true })))
    vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
end

function M.run()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end
    local build_dir = root .. "/build"
    local files = vim.fn.glob(build_dir .. "/*.polydev", true, true)
    if #files == 0 then return print("Error: No .polydev file found in build directory.") end
    utils.open_float_terminal("cd " .. build_dir .. " && ./" .. files[1]:match("([^/]+)%.polydev$"))
end

return M
