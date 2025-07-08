# Fix for snacks.nvim module loading issues that cause malloc crash
{ config, lib, ... }:
{
  plugins.snacks = {
    # Ensure snacks is properly initialized before use
    settings = {
      # Disable version check that might be causing the issue
      notifier = {
        enabled = true;
        # Disable version notifications
        skip_version_check = true;
      };
    };
  };

  # Add initialization to handle module loading issues
  extraConfigLuaPre = ''
    -- Workaround for snacks.nvim module loading issue
    local snacks_ok = pcall(require, "snacks")
    if snacks_ok then
      -- Pre-load modules to avoid runtime loading issues
      local modules_to_preload = {
        "snacks.picker",
        "snacks.picker.util",
        "snacks.picker.source",
      }
      
      for _, module in ipairs(modules_to_preload) do
        pcall(require, module)
      end
    end
    
    -- Specifically handle the version module issue
    package.loaded["snacks.version"] = package.loaded["snacks.version"] or "unknown"
  '';

  # Alternative fix: Override the __index metamethod that's failing
  extraConfigLua = ''
    -- Patch snacks to handle missing version module
    local snacks_loaded, snacks = pcall(require, "snacks")
    if snacks_loaded then
      local mt = getmetatable(snacks) or {}
      local original_index = mt.__index
      
      mt.__index = function(t, k)
        -- Special handling for version
        if k == "version" then
          return "nixvim-patched"
        end
        
        -- Call original __index with error handling
        local ok, result = pcall(function()
          if type(original_index) == "function" then
            return original_index(t, k)
          else
            return original_index[k]
          end
        end)
        
        if not ok then
          -- Log the error but don't crash
          vim.notify("Snacks module load error: " .. tostring(result), vim.log.levels.WARN)
          return nil
        end
        
        return result
      end
      
      setmetatable(snacks, mt)
    end
  '';
}