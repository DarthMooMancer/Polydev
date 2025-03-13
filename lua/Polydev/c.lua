local M = {}
M.close_key = nil
M.c_build = nil
M.c_run = nil
M.new_c_file = nil
M.new_c_header_file = nil
M.new_c_project = nil

M.config = {
  project_root = "~/Projects/C",
  keybinds = {
    ["<Esc>"] = "CloseTerminal",
    ["<leader>cb"] = "CBuild",
    ["<leader>cr"] = "CRun",
    ["<leader>cnf"] = "NewCFile",
    ["<leader>cnp"] = "NewCProject",
    ["<leader>cnh"] = "NewCHeaderFile",
  },
  terminal = {
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    top_padding = 0,
    border = true,
    number = true,
    relativenumber = true,
    scroll = true,
  }
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  for key, command in pairs(M.config.keybinds) do
    if command == "CloseTerminal" then M.close_key = key end
    if command == "CBuild" then M.c_build = key end
    if command == "CRun" then M.c_run = key end
    if command == "NewCFile" then M.new_c_file = key end
    if command == "NewCProject" then M.new_c_project = key end
    if command == "NewCHeaderFile" then M.new_c_header_file = key end
  end

  vim.api.nvim_create_user_command("NewCProject", M.create_project, {})
  vim.api.nvim_create_user_command("NewCHeaderFile", M.create_new_header_file, {})
  vim.api.nvim_create_user_command("NewCFile", M.create_new_file, {})
  vim.api.nvim_create_user_command("CBuild", M.build, {})
  vim.api.nvim_create_user_command("CRun", M.run, {})

  vim.keymap.set("n", M.c_build, ":CBuild<CR>", { silent = true })
  vim.keymap.set("n", M.c_run, ":CRun<CR>", { silent = true })
  vim.keymap.set("n", M.new_c_file, ":NewCFile<CR>", { silent = true })
  vim.keymap.set("n", M.new_c_project, ":NewCProject<CR>", { silent = true })
  vim.keymap.set("n", M.new_c_header_file, ":NewCHeaderFile<CR>", { silent = true })
end

function M.open_float_terminal(cmd)
  local ui = vim.api.nvim_list_uis()[1]
  local term_cfg = M.config.terminal

  local width = math.max(1, math.floor(ui.width * 0.9) - term_cfg.left_padding - term_cfg.right_padding)
  local height = math.max(1, math.floor(ui.height * 0.9) - term_cfg.top_padding - (term_cfg.bottom_padding + 1))
  local row = math.max(1, math.floor((ui.height - height) / 2) + term_cfg.top_padding)
  local col = math.max(1, math.floor((ui.width - width) / 2) + term_cfg.left_padding)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = term_cfg.border and "rounded" or "none",
  })

  vim.api.nvim_win_set_option(win, "winblend", vim.o.pumblend)
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Pmenu,FloatBorder:Pmenu")
  vim.api.nvim_win_set_option(win, "cursorline", true)
  if(term_cfg.number == true) then
    vim.api.nvim_win_set_option(win, "number", true)
    if(term_cfg.relativenumber == true) then
      vim.api.nvim_win_set_option(win, "relativenumber", true)
    end
  end
  if(term_cfg.scroll == true) then
    vim.api.nvim_win_set_option(win, "scrolloff", 5)
  end

  vim.fn.termopen(cmd)
  vim.api.nvim_buf_set_keymap(buf, "n", M.close_key, "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
  return buf, win
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
    if not project_name or project_name == "" then
      print("Project creation canceled.")
      return
    end

    local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
    for _, path in ipairs({ "/src", "/build", "/include" }) do
      vim.fn.mkdir(project_root .. path, "p")
    end

    write_file(project_root .. "/build/" .. project_name .. ".polydev", project_name)
    write_file(project_root .. "/src/main.c", [[
#include <stdio.h>

int main() {
  printf("Hello World\n");
  return 0;
}
]])

    write_file(project_root .. "/CMakeLists.txt", string.format([[
cmake_minimum_required(VERSION 3.10)
project(%s C)
set(CMAKE_C_STANDARD 11)
include_directories(include)

set(SOURCES src/main.c)
add_executable(%s ${SOURCES})
]], project_name, project_name))

    vim.cmd("edit " .. project_root .. "/src/main.c")
  end)
end

function M.create_new_file()
  vim.ui.input({ prompt = "Enter file name: " }, function(class_name)
    if not class_name or class_name == "" then return print("File creation canceled.") end
    local root_dir = M.get_project_root()
    if not root_dir then return print("Error: Project root not found.") end
    local file_path = root_dir .. "/src/" .. class_name .. ".c"
    assert(io.open(file_path, "w")):close()
    vim.cmd("edit " .. file_path)
    print(class_name .. ".c created successfully!")
  end)
end

function M.create_new_header_file()
  vim.ui.input({ prompt = "Enter header file name: " }, function(header_name)
    if not header_name then return print("Header file creation canceled.") end
    local root_dir = vim.fn.expand("%:p:h"):match("(.*)/src")
    if not root_dir then return print("Error: src directory not found.") end
    local guard_macro = header_name:upper():gsub("[^A-Z0-9]", "_") .. "_H"
    local content = string.format([[
#ifndef %s
#define %s

#include <stdio.h>

// Function prototypes
void example_function();

#endif // %s
]], guard_macro, guard_macro, guard_macro)
    write_file(root_dir .. "/include/" .. header_name .. ".h", content)
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
  local cmd = "cd " .. root .. "/build && cmake .. && make"
  local term_buf = M.open_float_terminal(cmd)
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
  M.open_float_terminal("cd " .. build_dir .. " && ./" .. files[1]:match("([^/]+)%.polydev$"))
end

return M
