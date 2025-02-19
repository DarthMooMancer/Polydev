local M = {}

local augroup = vim.api.nvim_create_augroup("nvim-java", { clear = true })

-- Helper function for creating directories
local function mkdir(path)
  os.execute("mkdir -p " .. path)
end

-- Helper function for writing to a file
local function write_file(path, content)
  local file = io.open(path, "w")
  if file then
    file:write(content)
    file:close()
  else
    print("Error writing to file: " .. path)
  end
end

-- Function to create a new Java project
local function create_java_project()
  vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
    if not project_name or project_name == "" then
      print("Project creation canceled.")
      return
    end

    local project_root = vim.fn.expand("~") .. "/Projects/" .. project_name
    local src_dir = project_root .. "/root/src"
    local out_dir = project_root .. "/root/out"

    mkdir(src_dir)
    mkdir(out_dir)

    -- Create a Main.java file
    local main_java_path = src_dir .. "/Main.java"
    local main_java_content = [[
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
]]
    write_file(main_java_path, main_java_content)

    -- Open Main.java in Neovim
    vim.cmd("edit " .. main_java_path)
    print("Java project '" .. project_name .. "' created at " .. project_root)
  end)
end

-- Function to create a new Java file
local function create_new_java_file()
  vim.ui.input({ prompt = "Enter class name for new Java file: " }, function(class_name)
    if not class_name or class_name == "" then
      print("Class creation canceled.")
      return
    end

    local current_dir = vim.fn.expand("%:p:h")
    local root_dir = current_dir:match("(.*)/root/src")
    if not root_dir then
      print("Error: src directory not found.")
      return
    end

    local src_dir = root_dir .. "/root/src"
    local java_file_path = src_dir .. "/" .. class_name .. ".java"

    local java_content = string.format([[
public class %s {
  // New File
}
]], class_name)

    write_file(java_file_path, java_content)
    vim.cmd("edit " .. java_file_path)
    print(class_name .. ".java created successfully!")
  end)
end

-- Function to build Java project
local function javabuild()
  local current_dir = vim.fn.expand("%:p:h")
  local project_root = current_dir:match("(.*)/root/src")

  if not project_root then
    print("Error: You must be inside the 'src' directory of a project.")
    return
  end

  local src_dir = project_root .. "/root/src"
  local out_dir = project_root .. "/root/out"
  mkdir(out_dir)

  local compile_command = "javac -d " .. out_dir .. " " .. src_dir .. "/*.java"
  local compile_status = vim.fn.system(compile_command)

  if vim.v.shell_error ~= 0 then
    print("Error during compilation:\n" .. compile_status)
  else
    print("Compilation successful!")
  end
end

-- Floating terminal for Java execution
local function open_float_terminal(cmd)
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.9)
  local height = math.floor(ui.height * 0.9)
  local row = math.floor(ui.height * 0.05)
  local col = math.floor(ui.width * 0.05)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width - 10,
    height = height - 10,
    row = row + 5,
    col = col + 5,
    style = "minimal",
    border = "none",
  })

  vim.api.nvim_win_set_option(win, "winblend", vim.o.pumblend)
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Pmenu,FloatBorder:Pmenu")

  vim.fn.termopen(cmd)
  vim.cmd("startinsert")

  -- Keymaps to close the terminal
  vim.api.nvim_buf_set_keymap(buf, "t", "<Esc>", "<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'i', '<Esc>', '<Esc>:q!<CR>', { noremap = true, silent = true })

  return buf, win
end

-- Function to run Java project in floating terminal
local function javarun_float()
  local current_dir = vim.fn.expand("%:p:h")
  local project_root = current_dir:match("(.*)/root/src")

  if not project_root then
    print("Error: You must be inside the 'src' directory of a project.")
    return
  end

  local out_dir = project_root .. "/root/out"
  open_float_terminal("java -cp " .. out_dir .. " Main")
end

-- Setup function to register commands
function M.setup()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    desc = "Register Java project commands",
    once = true,
    callback = function()
      vim.api.nvim_create_user_command("NewJavaProject", create_java_project, {})
      vim.api.nvim_create_user_command("JavaBuild", javabuild, {})
      vim.api.nvim_create_user_command("NewJavaFile", create_new_java_file, {})
      vim.api.nvim_create_user_command("JavaRun", javarun_float, {})
    end,
  })
end

return M
