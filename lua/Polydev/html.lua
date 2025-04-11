local M = {}
M.html_build = nil
M.html_run = nil

M.config = {
    project_root = "~/Projects/Html",
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

local function write_file(path, content)
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
    print(path .. " created successfully!")
end

function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
	if not project_name or project_name == "" then return print("Project creation canceled.") end
	local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name

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

	write_file(project_root .. "index.html", main_html_content)
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

	write_file("./" .. page .. ".html", html_content)
    end)
end

return M
