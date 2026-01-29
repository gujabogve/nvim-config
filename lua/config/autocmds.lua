-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_user_command("DiffClipboard", function()
  -- Create a temporary file with clipboard contents
  local temp_file = vim.fn.tempname()
  vim.fn.system("wl-paste > " .. temp_file)

  -- Open diff of current buffer against clipboard contents
  vim.cmd("vert diffsplit " .. temp_file)

  -- Optional: Auto-remove temporary file when buffer is closed
  vim.api.nvim_create_autocmd("BufDelete", {
    callback = function()
      os.remove(temp_file)
    end,
  })
end, {})

vim.api.nvim_create_user_command("CloseDiff", function()
  -- Turn off diff mode for all windows
  vim.cmd("windo diffoff")

  -- Close all temporary or diff-related buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if buffer is temporary or a diff buffer
    if vim.bo[buf].buftype == "nofile" or vim.fn.bufname(buf):match("^/tmp/") or vim.fn.bufname(buf) == "" then
      -- Try to delete the buffer
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end

  -- Close extra windows and return to original window
  while #vim.api.nvim_list_wins() > 1 do
    vim.cmd("close")
  end
end, {})
