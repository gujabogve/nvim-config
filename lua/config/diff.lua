local M = {}

-- Open diff of current buffer against clipboard contents
function M.diff_clipboard()
  -- Create a temporary file with clipboard contents
  local temp_file = vim.fn.tempname()
  -- Using wl-paste for linux
  local res = vim.fn.system("wl-paste")
  if vim.v.shell_error ~= 0 then
    vim.notify("Clipboard is empty or wl-paste failed", vim.log.levels.ERROR)
    return
  end
  local f = io.open(temp_file, "w")
  if f then
    f:write(res)
    f:close()
  else
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
    return
  end

  local ft = vim.bo.filetype
  -- Open diff of current buffer against clipboard contents
  vim.cmd("vert diffsplit " .. temp_file)
  vim.api.nvim_set_option_value("filetype", ft, { buf = 0 })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = 0 })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = 0 })

  -- Optional: Auto-remove temporary file when buffer is closed
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      os.remove(temp_file)
    end,
  })
end

-- Open diff of current buffer against same file in another branch
function M.diff_branch()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  builtin.git_branches({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if not selection then
          return
        end
        local branch = selection.value

        local current_file = vim.api.nvim_buf_get_name(0)
        local relative_file = vim.fn.systemlist("git ls-files --full-name " .. vim.fn.shellescape(current_file))[1]
        
        if not relative_file or relative_file == "" then
          vim.notify("File not tracked by git", vim.log.levels.ERROR)
          return
        end
        
        -- Get file content from branch
        local cmd = "git show " .. branch .. ":" .. relative_file
        local content = vim.fn.system(cmd)
        
        if vim.v.shell_error ~= 0 then
          vim.notify("File not found in branch " .. branch, vim.log.levels.ERROR)
          return
        end

        local temp_file = vim.fn.tempname()
        local f = io.open(temp_file, "w")
        if f then
          f:write(content)
          f:close()
        else
          vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
          return
        end

        local ft = vim.bo.filetype
        -- Open diff
        vim.cmd("vert diffsplit " .. temp_file)
        vim.api.nvim_set_option_value("filetype", ft, { buf = 0 })
        vim.api.nvim_set_option_value("buftype", "nofile", { buf = 0 })
        vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = 0 })

        -- Auto-remove temporary file when buffer is closed
        vim.api.nvim_create_autocmd("BufDelete", {
          buffer = vim.api.nvim_get_current_buf(),
          callback = function()
            os.remove(temp_file)
          end,
        })
      end)
      return true
    end,
  })
end

function M.close_diff()
  -- Turn off diff mode for all windows
  vim.cmd("windo diffoff")

  -- Close all temporary or diff-related buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "nofile" or vim.fn.bufname(buf):match("^/tmp/") or vim.fn.bufname(buf) == "" then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end

  -- Close extra windows and return to original window
  while #vim.api.nvim_list_wins() > 1 do
    vim.cmd("close")
  end
end

return M
