local M = {}
M.close_key = nil
M.c_build = nil
M.c_run = nil
M.new_c_file = nil
M.new_c_project = nil
M.build_term_buf = nil
M.build_term_win = nil  -- Store the window reference for the build terminal

-- Default config
M.config = {
  project_root = "~/Projects/C",
  keybinds = {
    ["<Esc>"] = "CloseTerminal",
    ["<leader>cb"] = "CBuild",
    ["<leader>cr"] = "CRun",
    ["<leader>cnf"] = "NewCFile",
    ["<leader>cnp"] = "NewCProject",
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

  -- Apply keybindings manually
  for key, command in pairs(M.config.keybinds) do
    if command == "CloseTerminal" then
      M.close_key = key
    end
    if command == "CBuild" then
      M.c_build = key
    end
    if command == "CRun" then
      M.c_run = key
    end
    if command == "NewCFile" then
      M.new_c_file = key
    end
    if command == "NewCProject" then
      M.new_c_project = key
    end
  end

  -- Register Keybinds
  vim.keymap.set("n", M.c_build, ":CBuild<CR>", { silent = true })
  vim.keymap.set("n", M.c_run, ":CRun<CR>", { silent = true })
  vim.keymap.set("n", M.new_c_file, ":NewCFile<CR>", { silent = true })
  vim.keymap.set("n", M.new_c_project, ":NewCProject<CR>", { silent = true })

  -- Register user commands
  vim.api.nvim_create_user_command("NewCProject", M.create_project, {})
  vim.api.nvim_create_user_command("NewCFile", M.create_new_file, {})
  vim.api.nvim_create_user_command("CBuild", M.build, {})
  vim.api.nvim_create_user_command("CRun", M.run, {})
end

-- Open floating terminal
function M.open_float_terminal(cmd)
  local ui = vim.api.nvim_list_uis()[1]
  local term_cfg = M.config.terminal

  -- Default window size (90% of the editor)
  local default_width = math.floor(ui.width * 0.9)
  local default_height = math.floor(ui.height * 0.9)

  -- Default centered position
  local default_row = math.floor((ui.height - default_height) / 2)
  local default_col = math.floor((ui.width - default_width) / 2)

  -- Adjust size based on padding
  local width = default_width - term_cfg.left_padding - term_cfg.right_padding
  local height = default_height - term_cfg.top_padding - (term_cfg.bottom_padding + 1)

  -- Adjust position based on padding
  local row = default_row + term_cfg.top_padding
  local col = default_col + term_cfg.left_padding

  -- Ensure window size doesn't go negative
  width = math.max(1, width)
  height = math.max(1, height)
  -- Ensure position doesn't move off-screen
  row = math.max(0, row)
  col = math.max(0, col)

  -- Create buffer and window
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

  -- Enable scrolling, relative line numbers, and prevent closing on click
  vim.api.nvim_win_set_option(win, "winblend", vim.o.pumblend)
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Pmenu,FloatBorder:Pmenu")
  if(M.config.terminal.number == true) then
    vim.api.nvim_win_set_option(win, "number", true)
  end
  if(M.config.terminal.number == true and M.config.terminal.relativenumber == true) then
    vim.api.nvim_win_set_option(win, "relativenumber", true)
  end
  if(M.config.terminal.scroll == true) then
    vim.api.nvim_win_set_option(win, "scrolloff", 5)
  end
  vim.api.nvim_win_set_option(win, "cursorline", true)

  vim.fn.termopen(cmd)

  vim.api.nvim_buf_set_keymap(buf, "n", M.close_key, "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })

  -- Store the terminal buffer and window for later use
  M.build_term_buf = buf
  M.build_term_win = win

  return buf, win
end

function M.build()
  -- Close the build terminal if it's open before running the build
  if M.build_term_buf and vim.api.nvim_buf_is_valid(M.build_term_buf) then
    vim.api.nvim_buf_delete(M.build_term_buf, { force = true })
    vim.api.nvim_win_close(M.build_term_win, true)
    M.build_term_buf = nil
    M.build_term_win = nil
  end

  -- Get the current file's directory
  local current_dir = vim.fn.expand("%:p:h")
  -- Try to find the root of the project by matching the path
  local project_root = current_dir:match("(.*)/src")
  if not project_root then
    print("Error: src directory not found.")
    return
  end

  -- Define the build directory
  local build_dir = project_root .. "/build"
  
  -- List files in the build directory and find the .txt file
  local files = vim.fn.glob(build_dir .. "/*.txt", true, true)
  if #files == 0 then
    print("Error: No .txt file found in the build directory.")
    return
  end

  -- Extract the project name from the .txt file's name (without the .txt extension)
  local project_name = vim.fn.fnamemodify(files[1], ":r")  -- :r removes the file extension

  -- Build command
  local compile_command = "cd " .. build_dir .. " && cmake .. && make"
  
  -- Open floating terminal to execute the build command
  local term_buf = M.open_float_terminal(compile_command)
  vim.api.nvim_buf_set_option(term_buf, "modifiable", true)

  -- Run compile command and capture output
  local compile_status = vim.fn.system(compile_command)

  -- Set message based on compile result
  local message
  if vim.v.shell_error ~= 0 then
    message = {"Error during compilation:"}
    -- Add each line of the compile_status as individual strings in the message array
    for _, line in ipairs(vim.split(compile_status, "\n")) do
      table.insert(message, line)
    end
  else
    message = {"Compilation successful!"}
  end

  -- Display message in terminal
  vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, message)
  vim.api.nvim_buf_set_option(term_buf, "modifiable", false)
end

function M.run()
  -- Close the build terminal if it's open before running the program
  if M.build_term_buf and vim.api.nvim_buf_is_valid(M.build_term_buf) then
    vim.api.nvim_buf_delete(M.build_term_buf, { force = true })
    vim.api.nvim_win_close(M.build_term_win, true)
    M.build_term_buf = nil
    M.build_term_win = nil
  end

  local current_dir = vim.fn.expand("%:p:h")
  local project_root = current_dir:match("(.*)/src")
  if not project_root then
    print("Error: Must be inside the 'src' directory.")
    return
  end

  local out_dir = project_root .. "/build"
  M.open_float_terminal("java -cp " .. out_dir .. " Main")
end

return M

