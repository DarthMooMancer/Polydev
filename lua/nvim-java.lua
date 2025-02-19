local function create_java_project()
  -- Get project name from user input
  vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
    if not project_name or project_name == "" then
      print("Project creation canceled.")
      return
    end

    -- Define the project root path within ~/Projects
    local project_root = vim.fn.expand("~") .. "/Projects/" .. project_name

    -- Define the directory paths
    local root_dir = project_root .. "/root"
    local src_dir = root_dir .. "/src"
    local out_dir = root_dir .. "/out"

    -- Create the directories if they don't exist
    os.execute("mkdir -p " .. src_dir)
    os.execute("mkdir -p " .. out_dir)

    -- Create Main.java in src/
    local main_java_path = src_dir .. "/Main.java"
    local main_java_content = [[
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
]]
    -- Write Main.java file
    local file = io.open(main_java_path, "w")
    if file then
      file:write(main_java_content)
      file:close()
    else
      print("Error creating Main.java")
      return
    end

    -- Open Main.java in Neovim
    vim.cmd("edit " .. main_java_path)
    print("Java project '" .. project_name .. "' created successfully at " .. project_root)
  end)
end

local function create_new_java_file()
  -- Get the class name for the new Java file
  vim.ui.input({ prompt = "Enter class name for new Java file: " }, function(class_name)
    if not class_name or class_name == "" then
      print("Class creation canceled.")
      return
    end

    -- Get the current working directory
    local current_dir = vim.fn.expand("%:p:h")

    -- Check if we're in a valid project directory
    local root_dir = current_dir:match("(.*)/root/src")  -- Try to extract the project root
    if not root_dir then
      print("Error: src directory not found.")
      return
    end

    -- Construct the path to the src directory dynamically
    local src_dir = root_dir .. "/root/src"

    -- Ensure that the src directory exists
    if vim.fn.isdirectory(src_dir) == 0 then
      print("Error: src directory not found.")
      return
    end

    local java_file_path = src_dir .. "/" .. class_name .. ".java"

    -- Java content template
    local java_content = string.format([[
public class %s {
  // New File
}
]], class_name)

    -- Write the Java class to the file
    local file = io.open(java_file_path, "w")
    if file then
      file:write(java_content)
      file:close()
      vim.cmd("edit " .. java_file_path)
      print( class_name .. ".java created successfully!")
    else
      print("Error creating " .. class_name .. ".java")
    end
  end)
end

local function javabuild()
  -- Get the current directory (where the user is editing)
  local current_dir = vim.fn.expand("%:p:h")

  -- Try to extract the project root by looking for "root/src" in the path
  local project_root = current_dir:match("(.*)/root/src")

  if not project_root then
    print("Error: You must be inside the 'src' directory of a project.")
    return
  end

  -- Define the source and output directories
  local src_dir = project_root .. "/root/src"
  local out_dir = project_root .. "/root/out"

  -- Ensure that the output directory exists
  vim.fn.mkdir(out_dir, "p")

  -- Compile all Java files in the src/ directory and output to out/
  local compile_command = "javac -d " .. out_dir .. " " .. src_dir .. "/*.java"
  local compile_status = vim.fn.system(compile_command)

  -- Check if the compilation was successful
  if vim.v.shell_error ~= 0 then
    print("Error during compilation:\n" .. compile_status)
    return
  end

  print("Compilation successful!")
end
local function open_float_terminal(cmd)
  -- Get the total dimensions of the Neovim window
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.9)   -- 90% of the window width
  local height = math.floor(ui.height * 0.9) -- 90% of the window height
  local row = math.floor(ui.height * 0.05)   -- 5% padding top
  local col = math.floor(ui.width * 0.05)    -- 5% padding left/right

  -- Create a new buffer for the floating terminal
  local buf = vim.api.nvim_create_buf(false, true)  -- Create a new buffer (no file, no listed)

  -- Floating window options
  local opts = {
    relative = 'editor',
    width = width - 10,  -- Account for left/right padding
    height = height - 10, -- Account for top/bottom padding
    row = row + 5,        -- Shift down for padding
    col = col + 5,        -- Shift right for padding
    style = "minimal",    -- Removes unnecessary UI elements
    border = "none",      -- Removes border for transparency
  }

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Apply transparency and Pmenu styling
  vim.api.nvim_win_set_option(win, "winblend", vim.o.pumblend) -- Match `Pmenu` transparency
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Pmenu,FloatBorder:Pmenu")

  -- Enable line numbers in the floating window
  vim.api.nvim_win_set_option(win, "number", true)
  vim.api.nvim_win_set_option(win, "relativenumber", false)  -- Use absolute line numbers

  -- Start the interactive terminal
  vim.fn.termopen(cmd)

  -- Automatically enter insert mode for smooth interaction
  vim.cmd("startinsert")

  -- Map <Esc> in terminal and normal mode to close the floating window
  vim.api.nvim_buf_set_keymap(buf, "t", "<Esc>", "<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'i', '<Esc>', '<Esc>:q!<CR>', { noremap = true, silent = true })

  return buf, win
end

local function javarun_float()
  -- Get the current directory (where the user is editing)
  local current_dir = vim.fn.expand("%:p:h")

  -- Try to extract the project root by looking for "root/src" in the path
  local project_root = current_dir:match("(.*)/root/src")

  if not project_root then
    print("Error: You must be inside the 'src' directory of a project.")
    return
  end

  -- Define the output directory where the .class files are located
  local out_dir = project_root .. "/root/out"

  -- Run the Main class from the output directory in the floating terminal
  open_float_terminal("java -cp " .. out_dir .. " Main")
end

-- Register Neovim commands
vim.api.nvim_create_user_command("NewJavaProject", create_java_project, {})
vim.api.nvim_create_user_command("JavaBuild", javabuild, {})
vim.api.nvim_create_user_command("NewJavaFile", create_new_java_file, {})
vim.api.nvim_create_user_command("JavaRun", javarun_float, {})
