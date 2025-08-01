# Extreme workaround: Completely filter out Haskell files from telescope/snacks
{ config, lib, ... }:
{
  # Since selecting Haskell files causes crashes, filter them out completely
  
  plugins.telescope.settings = {
    defaults = {
      # Ignore all Haskell files
      file_ignore_patterns = [
        "%.hs$"
        "%.lhs$" 
        "%.hsc$"
        "%.hs%-boot$"
      ];
    };
    
    pickers = {
      find_files = {
        # Additional ignore for find_files specifically
        find_command = [
          "fd"
          "--type"
          "f"
          "--hidden"
          "--exclude"
          "*.hs"
          "--exclude"
          "*.lhs"
          "--exclude"
          "*.hsc"
        ];
      };
      
      live_grep = {
        # Exclude Haskell files from grep
        glob_pattern = "!*.{hs,lhs,hsc}";
      };
    };
  };
  
  # Same for snacks if it gets re-enabled
  plugins.snacks.settings.picker = {
    files = {
      exclude = [
        "*.hs"
        "*.lhs"
        "*.hsc"
      ];
    };
  };
  
  # Provide a special command to explicitly search Haskell files with a different method
  extraConfigLua = ''
    -- Command to open Haskell files using vim's native commands (no telescope)
    vim.api.nvim_create_user_command("FindHaskell", function(opts)
      -- Use vim's wildmenu instead
      if opts.args ~= "" then
        vim.cmd("find **/" .. opts.args .. "*.hs")
      else
        vim.cmd("args **/*.hs | argument 1")
      end
    end, {
      nargs = "?",
      desc = "Find Haskell files without telescope"
    })
    
    -- Show warning when in Haskell projects
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        local has_haskell = vim.fn.glob("**/*.hs", false, true)
        if #has_haskell > 0 then
          vim.notify(
            "Haskell files detected. Use :FindHaskell or :e to open them (telescope will ignore them)",
            vim.log.levels.INFO
          )
        end
      end
    })
    
    -- Alternative: Use quickfix for Haskell files
    vim.keymap.set('n', '<leader>fH', function()
      vim.cmd("silent! vimgrep /\\v^(module|import|data|type|class|instance)/ **/*.hs")
      vim.cmd("copen")
    end, {desc = "Find Haskell definitions (quickfix)"})
  '';
}