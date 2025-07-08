-- Debug script to trace what happens when selecting files in telescope
-- Run this in the problematic repository with: nvim -u debug-telescope-selection.lua

-- Minimal init
vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.cmd [[set packpath=/tmp/nvim-debug]]

-- Set up logging
local log_file = io.open("/tmp/telescope-debug.log", "w")
local function log(msg)
  if log_file then
    log_file:write(os.date("%H:%M:%S") .. " " .. msg .. "\n")
    log_file:flush()
  end
  print(msg)
end

-- Track all autocommands
vim.api.nvim_create_autocmd("*", {
  callback = function(args)
    log(string.format("Autocmd fired: %s (buf=%s, file=%s)", 
      args.event, 
      args.buf,
      vim.fn.expand("<afile>")
    ))
  end
})

-- Override buffer creation to catch issues
local orig_nvim_create_buf = vim.api.nvim_create_buf
vim.api.nvim_create_buf = function(listed, scratch)
  log(string.format("Creating buffer: listed=%s, scratch=%s", listed, scratch))
  local ok, buf = pcall(orig_nvim_create_buf, listed, scratch)
  if not ok then
    log("ERROR creating buffer: " .. tostring(buf))
    error(buf)
  end
  return buf
end

-- Track file operations
local orig_nvim_buf_set_name = vim.api.nvim_buf_set_name
vim.api.nvim_buf_set_name = function(buf, name)
  log(string.format("Setting buffer name: buf=%d, name=%s", buf, name))
  if name:match("xmon") then
    log("WARNING: Setting buffer name containing 'xmon'")
  end
  return orig_nvim_buf_set_name(buf, name)
end

-- Load only telescope
vim.cmd [[packadd plenary.nvim]]
vim.cmd [[packadd telescope.nvim]]

-- Minimal telescope setup
require('telescope').setup{
  defaults = {
    -- Disable everything that might cause issues
    preview = false,
    file_ignore_patterns = {},
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
    },
  },
}

-- Create command to test
vim.api.nvim_create_user_command('TestTelescope', function()
  log("Starting telescope find_files")
  
  -- Wrap in pcall to catch crashes
  local ok, err = pcall(function()
    require('telescope.builtin').find_files({
      attach_mappings = function(_, map)
        -- Log when items are selected
        map('i', '<CR>', function(prompt_bufnr)
          local entry = require('telescope.actions.state').get_selected_entry()
          log("Selected: " .. tostring(entry and entry.path))
          require('telescope.actions').close(prompt_bufnr)
        end)
        
        -- Log when cursor moves
        map('i', '<Down>', function()
          log("Cursor moved down")
          return false -- Let default action happen
        end)
        
        return true
      end,
      
      -- Minimal picker
      previewer = false,
      layout_strategy = 'vertical',
      layout_config = {
        height = 0.5,
      },
    })
  end)
  
  if not ok then
    log("ERROR: " .. tostring(err))
  end
end, {})

print([[
Debug mode enabled. Logging to /tmp/telescope-debug.log

Commands:
  :TestTelescope - Open telescope find_files
  :messages - See vim messages
  
Try searching for "xmon" and watch for errors.
Press Ctrl-C if it hangs.
]])

-- Cleanup on exit
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    if log_file then
      log_file:close()
    end
  end
})