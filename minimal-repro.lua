-- Minimal reproduction script for the malloc crash
-- Save this file and run: nvim -u minimal-repro.lua

-- Set up minimal environment
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/snacks.nvim")

-- Load only snacks
local ok, snacks = pcall(require, "snacks")
if not ok then
  print("Failed to load snacks.nvim")
  return
end

-- Enable debug mode
snacks.setup({
  picker = {
    debug = {
      scores = true,
      leaks = true,
      files = true,
      proc = true,
    },
  },
})

-- Create test command
vim.api.nvim_create_user_command("TestX", function()
  print("Testing search for 'x'...")
  
  -- Log before search
  local log = io.open("/tmp/test-x-search.log", "w")
  if log then
    log:write("Starting search at: " .. os.date() .. "\n")
    log:write("CWD: " .. vim.fn.getcwd() .. "\n")
    log:close()
  end
  
  -- Try the search
  local success, err = pcall(function()
    snacks.picker.files({ pattern = "x" })
  end)
  
  if not success then
    print("Error: " .. tostring(err))
  end
end, {})

print("Minimal config loaded. Run :TestX to test the search")