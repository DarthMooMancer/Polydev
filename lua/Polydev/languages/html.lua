local utils = require("Polydev.utils")
local M = {}

M.opts = nil

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("html"), opts or {})
end

function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled.") end
	local project_root = vim.fn.expand(M.opts.project_root) .. "/" .. project_name

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
	utils.write_file(project_root .. "index.html", main_html_content)
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter page name: " }, function(page)
	if not page or page == "" then return print("Class creation canceled.") end
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

	utils.write_file("./" .. page .. ".html", html_content)
    end)
end

return M
