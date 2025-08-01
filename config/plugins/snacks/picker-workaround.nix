# Workaround configuration for snacks picker crash in specific repository
{ config, lib, ... }:
{
  plugins.snacks.settings.picker = {
    # Option 1: Disable picker for specific patterns
    files = {
      # Exclude files that might cause issues
      exclude = [
        "*.xml"
        "*.xls"
        "*.xlsx"
        "*.xhtml"
        "*.xsd"
        "*.xsl"
        "*.xslt"
      ];
      
      # Limit search depth
      max_depth = 10;
    };

    # Option 2: Use a different search command that might be more stable
    find_cmd.__raw = ''
      function()
        -- Use fd if available, with specific flags
        if vim.fn.executable("fd") == 1 then
          return { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--max-depth", "10" }
        else
          -- Fallback to find with limited depth
          return { "find", ".", "-maxdepth", "10", "-type", "f", "-not", "-path", "*/.git/*" }
        end
      end
    '';

    # Option 3: Add pre-search validation
    before_open.__raw = ''
      function(picker)
        -- Log what we're about to search
        local log = io.open("/tmp/snacks-picker-search.log", "a")
        if log then
          log:write(os.date("%Y-%m-%d %H:%M:%S") .. " - Starting search in: " .. vim.fn.getcwd() .. "\n")
          log:close()
        end
        
        -- Collect garbage before search to free memory
        collectgarbage("collect")
      end
    '';
  };

  # Alternative: Create a custom keymap that uses telescope for problematic repos
  keymaps = lib.mkIf config.plugins.telescope.enable [
    {
      mode = "n";
      key = "<leader>xf";
      action.__raw = ''
        function()
          -- Check if we're in the problematic repo
          local cwd = vim.fn.getcwd()
          if cwd:match("problematic%-repo") then
            -- Use telescope instead
            require('telescope.builtin').find_files({ 
              hidden = true,
              find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
            })
          else
            -- Use snacks picker normally
            Snacks.picker.files({ hidden = true })
          end
        end
      '';
      options = {
        desc = "Find files (with workaround)";
      };
    }
  ];
}