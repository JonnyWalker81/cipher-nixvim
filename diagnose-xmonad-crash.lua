-- Diagnostic script to test snacks picker with specific patterns
-- Run this in Neovim with :luafile diagnose-xmonad-crash.lua

local function test_search_patterns()
  print("=== Testing Snacks Picker Search Patterns ===\n")
  
  -- Test 1: Search for files starting with different letters
  local test_patterns = {"a", "m", "n", "w", "x", "y", "z"}
  
  for _, pattern in ipairs(test_patterns) do
    print("Testing pattern: " .. pattern)
    local success, err = pcall(function()
      -- Create a minimal picker config
      local files = vim.fn.systemlist("find . -name '" .. pattern .. "*' -type f 2>/dev/null | head -5")
      print("  Found " .. #files .. " files")
      
      -- Try to simulate what snacks picker does
      if pattern == "x" then
        print("  Testing 'x' pattern specifically...")
        -- Force garbage collection before
        collectgarbage("collect")
        
        -- Log memory usage
        local mem_before = collectgarbage("count")
        print("  Memory before: " .. mem_before .. " KB")
        
        -- Try different operations that might trigger the issue
        local test_str = "x"
        local test_table = {pattern = "x*", files = files}
        
        -- Test string operations
        local _ = test_str:sub(1, 1)
        local _ = test_str:match("^x")
        
        -- Log memory after
        local mem_after = collectgarbage("count")
        print("  Memory after: " .. mem_after .. " KB")
      end
    end)
    
    if not success then
      print("  ERROR: " .. tostring(err))
    else
      print("  ✓ Success")
    end
    print("")
  end
end

-- Test 2: Check for any special vim settings in this directory
local function check_vim_state()
  print("\n=== Checking Vim State ===")
  print("Current directory: " .. vim.fn.getcwd())
  print("File encoding: " .. vim.o.encoding)
  print("File format: " .. vim.o.fileformat)
  print("Shell: " .. vim.o.shell)
  print("Locale: " .. (vim.env.LANG or "not set"))
  
  -- Check if there are any autocommands that might interfere
  print("\nChecking for 'x' related autocommands...")
  vim.cmd("autocmd * *x*")
end

-- Test 3: Try to reproduce the exact picker call
local function test_picker_directly()
  print("\n=== Testing Snacks Picker Directly ===")
  
  -- Check if snacks is loaded
  local has_snacks, snacks = pcall(require, "snacks")
  if not has_snacks then
    print("Snacks not loaded!")
    return
  end
  
  print("Snacks version: " .. (snacks.version or "unknown"))
  
  -- Try a minimal picker call
  print("\nTrying minimal picker search...")
  local success, err = pcall(function()
    -- Don't actually open the picker, just test the search function
    local picker_config = {
      source = "files",
      pattern = "x",
      cwd = vim.fn.getcwd(),
    }
    print("Config: " .. vim.inspect(picker_config))
  end)
  
  if not success then
    print("ERROR: " .. tostring(err))
  else
    print("✓ Config created successfully")
  end
end

-- Run all tests
test_search_patterns()
check_vim_state()
test_picker_directly()

print("\n=== Diagnostic Complete ===")
print("If the crash happens during these tests, check the output above")
print("Also check: /tmp/snacks-picker-error.log")