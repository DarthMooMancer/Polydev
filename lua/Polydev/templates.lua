local utils = require("Polydev.utils")

local M = {}

M.projects = {
    java = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    for _, path in ipairs({ "/src", "/build" }) do vim.fn.mkdir(full_project_root .. path, "p") end
	    local content = [[
public class Main {
    public static void main(String[] args) {
	System.out.println("Hello, World!");
    }
}
]]
	    local gitignore = {
		"build/"
	    }
	    utils.init_git(full_project_root, gitignore)
	    utils.write_file({ full_project_root, "src", "Main.java" }, content)
	end
    },
    python = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    vim.fn.mkdir(full_project_root .. "/include", "p")
	    utils.write_file({ full_project_root,  "main.py" }, [[
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
]])
	    utils.write_file({ full_project_root, "include/__init__.py" }, "")
	    utils.write_file({ full_project_root, "requirements.txt" }, "")
	    utils.write_file({ full_project_root, "setup.py" }, string.format([[
from setuptools import setup, find_packages

setup(
    name="%s",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[],
    python_requires=">=3.6",
)
]], project_name))
	    local gitignore = {
		"venv/"
	    }
	    utils.init_git(full_project_root, gitignore)
	    vim.cmd("edit " .. full_project_root .. "/main.py")
	    local venv_path = full_project_root .. "/venv"
	    vim.fn.system("python3 -m venv " .. venv_path)
	    vim.g.python3_host_prog = venv_path .. "/bin/python"
	    vim.fn.setenv("VIRTUAL_ENV", venv_path)
	    vim.fn.setenv("PATH", venv_path .. "/bin:" .. vim.fn.getenv("PATH"))
	    print("Virtual environment activated for " .. project_name)
	end
    },
    lua = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    vim.fn.mkdir(full_project_root .. "/lua/" .. project_name, "p")
	    utils.write_file({ full_project_root, "lua", project_name, "init.lua" }, [[
local M = {}

return M
]])
	    local gitignore = { "" }
	    utils.init_git(full_project_root, gitignore)
	    vim.cmd("edit " .. full_project_root .. "/lua/" .. project_name .. "/init.lua")
	end
    },
    c = {
	run = function(project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    for _, path in ipairs({ "/src", "/build", "/include" }) do vim.fn.mkdir(full_project_root .. path, "p") end
	    utils.write_file({ full_project_root, "src/main.c" }, [[
#include <stdio.h>

int main() {
    printf("%s", "Hello World");
    return 0;
}
]])
	    utils.write_file({ full_project_root, "CMakeLists.txt" }, string.format([[
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
	    local gitignore = { "build/" }
	    utils.init_git(full_project_root, gitignore)
	    vim.fn.system(string.format("cd %s/build/ && cmake .. && cmake --build .", full_project_root))
	    vim.cmd("edit " .. full_project_root .. "/src/main.c")
	end
    },
    cpp = {
	run = function (project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    for _, path in ipairs({ "/src", "/build", "/include" }) do
		vim.fn.mkdir(full_project_root .. path, "p")
	    end
	    utils.write_file({ full_project_root, "src/main.cpp" }, [[
#include <iostream>

int main() {
    std::cout << "Hello World" << std::endl;
    return 0;
}
]])
	    utils.write_file({ full_project_root, "CMakeLists.txt" }, string.format([[
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

	    local gitignore = { "build/" }
	    utils.init_git(full_project_root, gitignore)
	    vim.fn.system(string.format("cd %s/build/ && cmake .. && cmake --build .", full_project_root))
	    vim.cmd("edit " .. full_project_root .. "/src/main.cpp")
	end
    },
    rust = {
	run = function (project_name, project_root)
	    local full_project_root = vim.fn.expand(project_root) .. "/" .. project_name
	    vim.fn.system("cargo new " .. full_project_root)
	    vim.cmd("edit " .. full_project_root .. "/src/main.rs")
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
	    utils.write_file({ full_project_root, "index.html" }, main_html_content)
	end
    },
}

M.files = {
    java = {
	run = function (file_name)
	    local root_dir = utils.get_project_root()
	    utils.write_file({ root_dir, "src", file_name .. ".java" }, string.format([[
public class %s {
    // New File
}
]], file_name))
	end
    },
    python = {
	run = function (file_name)
	    local root_dir = utils.get_project_root()
	    utils.write_file({ root_dir, "include", file_name .. ".py" }, "")
	end
    },
    lua = {
	run = function (file_name)
	    local root = utils.get_project_root()
	    utils.write_file({ root, "lua", utils.get_project_name(), file_name .. ".lua"}, "")
	end
    },
    c = {
	run = function (file_name)
	    local root_dir = utils.get_project_root()
	    utils.write_file({ root_dir, "src", file_name .. ".c" }, "")
	end

    },
    cpp = {
	run = function (file_name)
	    local root_dir = utils.get_project_root()
	    utils.write_file({ root_dir, "src", file_name .. ".cpp" }, "")
	end
    },
    rust = {
	run = function (file_name)
	    local root_dir = utils.get_project_root()
	    utils.write_file({ root_dir, "src", file_name .. ".rs" }, "")
	end
    },
    html = {
	run = function (file_name)
	    utils.write_file({ ".", file_name .. ".html" }, string.format([[
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
]]))
	end
    }
}

M.aux_files = {
    c = {
	run = function (file_name)
	    if not file_name then return print("Header file creation canceled") end
	    local root = utils.get_project_root()
	    local guard_macro = file_name:upper():gsub("[^A-Z0-9]", "_") .. "_H"
	    local content = string.format([[
#ifndef %s
#define %s

// Add code here

#endif
]], guard_macro, guard_macro)
	    utils.write_file({ root, "include", file_name .. ".h" }, content)
	end
    },
    cpp = {
	run = function(file_name)
	    if not file_name then return print("Header file creation canceled") end
	    local root = utils.get_project_root()
	    local guard_macro = file_name:upper():gsub("[^A-Z0-9]", "_") .. "_HPP"
	    local content = string.format([[
#ifndef %s
#define %s

// Add code here

#endif
]], guard_macro, guard_macro, guard_macro)
	    utils.write_file({ root, "include", file_name .. ".hpp" }, content)
	end
    }
}

function M.create_project(lang, project_root)
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled") end
	M.projects[lang].run(project_name, project_root)
    end)
end

function M.create_new_file(lang)
    vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
	if not file_name or file_name == "" then return print("File creation canceled") end
	M.files[lang].run(file_name)
    end)
end

function M.create_aux_file(lang)
    vim.ui.input({ promt = "Enter file name: "}, function(file_name)
	if not file_name or file_name == "" then return print("File creation canceled") end
	M.aux_files[lang].run(file_name)
    end)
end

return M
