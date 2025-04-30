--
--The main source of the plugin in which runs the creation of projects and files for languages
--

---@module 'Polydev.utils'
local utils = require("Polydev.utils")

---@type table 
local M = {}

---@class TemplateLanguage
---@field run fun(project_name: string, project_root: string): string

---@class Projects
---@field java TemplateLanguage
---@field python TemplateLanguage
---@field lua TemplateLanguage
---@field c TemplateLanguage
---@field cpp TemplateLanguage
---@field rust TemplateLanguage
---@field html TemplateLanguage
---@alias TemplatesLanguageName "java" | "python" | "lua" | "c" | "cpp" | "rust" | "html"

---@type Projects
M.projects = {
    java = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    for _, path in ipairs({ "/src", "/build" }) do vim.fn.mkdir(full_project_root .. path, "p") end
	    local main_java_content = [[
public class Main {
    public static void main(String[] args) {
	System.out.println("Hello, World!");
    }
}
]]
	    utils.write_file(full_project_root .. "/src/Main.java", main_java_content)
	    return full_project_root
	end
    },
    python = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    vim.fn.mkdir(full_project_root .. "/include", "p")
	    utils.write_file(full_project_root .. "/main.py", [[
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
]])
	    utils.write_file(full_project_root .. "/include/__init__.py", "")
	    utils.write_file(full_project_root .. "/requirements.txt", "")
	    utils.write_file(full_project_root .. "/setup.py", string.format([[
from setuptools import setup, find_packages

setup(
    name="%s",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[],
    python_requires=">=3.6",
)
]], project_name))
	    vim.cmd("edit " .. full_project_root .. "/main.py")
	    local venv_path = full_project_root .. "/venv"
	    vim.fn.system("python3 -m venv " .. venv_path)
	    vim.g.python3_host_prog = venv_path .. "/bin/python"
	    vim.fn.setenv("VIRTUAL_ENV", venv_path)
	    vim.fn.setenv("PATH", venv_path .. "/bin:" .. vim.fn.getenv("PATH"))
	    print("Virtual environment activated for " .. project_name)
	    return full_project_root
	end
    },
    lua = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    for _, path in ipairs({ "/lua/" .. project_name }) do vim.fn.mkdir(full_project_root .. path, "p") end
	    utils.write_file(full_project_root .. "/lua/" .. project_name .. "/init.lua", [[
local M = {}

return M
]])
	    utils.write_file(full_project_root .. "/" .. project_name .. ".polydev", "[[DO NOT REMOVE THIS FILE]]")
	    vim.cmd("edit " .. full_project_root .. "/lua/" .. project_name .. "/init.lua")
	    return full_project_root
	end
    },
    c = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    for _, path in ipairs({ "/src", "/build", "/include" }) do vim.fn.mkdir(full_project_root .. path, "p") end
	    utils.write_file(full_project_root .. "/build/" .. project_name .. ".polydev", project_name)
	    utils.write_file(full_project_root .. "/src/main.c", [[
#include <stdio.h>

int
main() {
    printf("%s", "Hello World");
    return 0;
}
]])
	    utils.write_file(full_project_root .. "/CMakeLists.txt", string.format([[
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
	    vim.cmd("edit " .. full_project_root .. "/src/main.c")
	    vim.fn.system(string.format("cd %s/build/ && cmake .. && cmake --build .", full_project_root))
	    return full_project_root
	end
    },
    cpp = {
	run = function (project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    for _, path in ipairs({ "/src", "/build", "/include" }) do
		vim.fn.mkdir(full_project_root .. path, "p")
	    end
	    utils.write_file(full_project_root .. "/build/" .. project_name .. ".polydev", project_name)
	    utils.write_file(full_project_root .. "/src/main.cpp", [[
#include <iostream>

int main() {
    std::cout << "Hello World" << std::endl;
    return 0;
}
]])
	    utils.write_file(full_project_root .. "/CMakeLists.txt", string.format([[
cmake_minimum_required(VERSION 3.10)
project(%s)
include_directories(include)
set(SOURCES src/main.cpp)
add_executable(%s ${SOURCES})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)

# find_package(SDL3 CONFIG REQUIRED) # An example of how to import libraries from vcpkg
# target_link_libraries(Game PRIVATE SDL3::SDL3)
]], project_name, project_name))

	    utils.write_file(full_project_root .. "/.gitignore", string.format([[
build/
]]))
	    vim.fn.system(string.format("cd %s/build/ && cmake .. && cmake --build .", full_project_root))
	    vim.cmd("edit " .. full_project_root .. "/src/main.cpp")
	    return full_project_root
	end
    },
    rust = {
	run = function (project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    vim.fn.system("cargo new " .. full_project_root)
	    vim.cmd("edit " .. full_project_root .. "/src/main.rs")
	    return full_project_root
	end
    },
    html = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    local main_html_content = [[
<!DOCTYPE html>
<html>
    <head>
	<title>Page Title</title>
    </head>
    <body>

	<h1>My First Heading</h1>
	<p>My first paragraph.</p>

    </body>
</html>
]]
	    utils.write_file(full_project_root .. "index.html", main_html_content)
	    return full_project_root
	end
    },
}

---@class TemplateFile
---@field run fun(file_name: string): nil

---@class Files
---@field java TemplateFile
---@field python TemplateFile
---@field lua TemplateFile
---@field c TemplateFile
---@field cpp TemplateFile
---@field rust TemplateFile
---@field html TemplateFile
---@alias TemplatesFileName "java" | "python" | "lua" | "c" | "cpp" | "rust" | "html"

---@type Files
M.files = {
    java = {
	run = function (file_name)
	    local root_dir = vim.fn.expand("%:p:h"):match("(.*)/src")
	    if not root_dir then return print("Error: src directory not found.") end
	    local java_content = string.format([[
public class %s {
    // New File
}
]], file_name)

	    utils.write_file(root_dir .. "/src/" .. file_name .. ".java", java_content)
	end
    },
    python = {
	run = function (file_name)
	    if not file_name:match("%.py$") then file_name = file_name .. ".py" end
	    local root_dir = M.get_project_root()
	    if not root_dir then return print("Error: Project root not found.") end
	    local file_path = root_dir .. "/include/" .. file_name
	    utils.write_file(file_path, "")
	end
    },
    lua = {
	run = function (file_name)
	    local function get_project_root()
		local dir = vim.fn.expand("%:p:h")
		while dir ~= "/" do
		    local polydev_file = vim.fn.glob(dir .. "/*.polydev")
		    if polydev_file ~= "" then return dir end
		    dir = vim.fn.fnamemodify(dir, ":h")
		end
		return nil
	    end
	    local function get_project_name() return vim.fn.glob((get_project_root() or "") .. "/*.polydev"):match("([^/]+)%.polydev$") end
	    if not get_project_root() or not get_project_name() then return print("Error: Project root not found.") end
	    utils.write_file(get_project_root() .. "/lua/" .. get_project_name() .. "/" .. file_name .. ".lua", "")
	end
    },
    c = {
	run = function (file_name)
	    local function get_project_root()
		local dir = vim.fn.expand("%:p:h")
		while dir ~= "/" do
		    if vim.fn.isdirectory(dir .. "/src") == 1 or vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1 then
			return dir
		    end
		    dir = vim.fn.fnamemodify(dir, ":h")
		end
	    end

	    if not file_name or file_name == "" then return print("File creation canceled.") end
	    local root_dir = get_project_root()
	    if not root_dir then return print("Error: Project root not found.") end
	    utils.write_file(root_dir .. "/src/" .. file_name .. ".c", "")
	end

    },
    cpp = {
	run = function (file_name)
	    local function get_project_root()
		local dir = vim.fn.expand("%:p:h")
		while dir ~= "/" do
		    if vim.fn.isdirectory(dir .. "/src") == 1 or vim.fn.filereadable(dir .. "/CMakeLists.txt") == 1 then
			return dir
		    end
		    dir = vim.fn.fnamemodify(dir, ":h")
		end
	    end
	    local root_dir = get_project_root()
	    if not root_dir then return print("Error: Project root not found.") end
	    utils.write_file(root_dir .. "/src/" .. file_name .. ".cpp", "")
	end
    },
    rust = {
	run = function (file_name)
	    local function get_project_root()
		local dir = vim.fn.expand("%:p:h")
		while dir ~= "/" do
		    if vim.fn.isdirectory(dir .. "/src") == 1 then
			return dir
		    end
		    dir = vim.fn.fnamemodify(dir, ":h")
		end
	    end
	    local root_dir = get_project_root()
	    if not root_dir then return print("Error: Project root not found.") end
	    utils.write_file(root_dir .. "/src/" .. file_name .. ".rs", "")
	end
    },
    html = {
	run = function (file_name)
	    local html_content = string.format([[
<!DOCTYPE html>
<html>
    <head>
	<title>Page Title</title>
    </head>
    <body>

	<h1>My First Heading</h1>
	<p>My first paragraph.</p>

    </body>
</html>
]])

	    utils.write_file("./" .. file_name .. ".html", html_content)
	end
    }
}

---@type string
M.dir = ""

---@param lang TemplatesLanguageName
---@param project_root string
function M.create_project(lang, project_root)
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled.") end
	M.dir = M.projects[lang].run(project_name, project_root)
    end)
end

---@param lang TemplatesFileName
function M.create_new_file(lang)
    vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
	if not file_name or file_name == "" then return print("File creation canceled.") end
	M.files[lang].run(file_name)
    end)
end

---@return any
return M
