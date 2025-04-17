---@module 'Polydev.utils'
local utils = require("Polydev.utils")
---
---@type table 
local M = {}

---@class TemplateLanguage
---@field run fun(project_name: string, project_root: string): nil

---@class Projects
---@field java TemplateLanguage
---@field python TemplateLanguage
---@field lua TemplateLanguage
---@alias TemplatesLanguageName "java" | "python" | "lua"

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
	return nil
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
	return nil
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
	return nil
	end
    },
}

---@param lang TemplatesLanguageName
---@param project_root string
function M.create_project(lang, project_root)
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled.") end
	M.projects[lang].run(project_name, project_root)
    end)
end

---@return any
return M
