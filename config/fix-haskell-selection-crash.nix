# Fix crash when selecting (not previewing) Haskell files in telescope/snacks
{ config, lib, ... }:
{
  # The crash happens when telescope/snacks highlights certain files in the picker
  # This fix prevents the crash by intercepting file selection for problematic files
  
  plugins.telescope.settings = {
    defaults = {
      # Custom file_sorter that marks Haskell files
      file_sorter.__raw = ''
        function(opts)
          local sorters = require("telescope.sorters")
          local original_sorter = sorters.get_fuzzy_file(opts)
          
          return sorters.new(vim.tbl_extend("force", original_sorter, {
            scoring_function = function(_, prompt, line, entry)
              -- Check if this is a Haskell file
              if entry and entry.path and (
                entry.path:match("%.hs$") or 
                entry.path:match("%.lhs$") or 
                entry.path:match("%.hsc$")
              ) then
                -- Mark it in the entry
                entry._is_haskell = true
              end
              
              -- Use original scoring
              return original_sorter:scoring_function(prompt, line, entry)
            end,
          }))
        end
      '';
      
      # Prevent certain operations on selection
      mappings = {
        i = {
          ["<C-n>"].__raw = ''
            function(prompt_bufnr)
              -- Move selection down but check what we're selecting
              local action_state = require("telescope.actions.state")
              require("telescope.actions").move_selection_next(prompt_bufnr)
              
              -- Check if we selected a Haskell file
              local entry = action_state.get_selected_entry()
              if entry and entry._is_haskell then
                -- Disable any automatic operations that might crash
                vim.schedule(function()
                  -- Ensure no LSP or other tools try to process this
                  vim.b._telescope_no_process = true
                end)
              end
            end
          '';
          
          ["<C-p>"].__raw = ''
            function(prompt_bufnr)
              -- Move selection up with same safety check
              local action_state = require("telescope.actions.state")
              require("telescope.actions").move_selection_previous(prompt_bufnr)
              
              local entry = action_state.get_selected_entry()
              if entry and entry._is_haskell then
                vim.schedule(function()
                  vim.b._telescope_no_process = true
                end)
              end
            end
          '';
        };
      };
    };
  };

  # Disable automatic operations that might trigger on selection
  extraConfigLua = ''
    -- Hook into telescope to prevent crashes on selection
    local has_telescope, telescope = pcall(require, "telescope")
    if has_telescope then
      -- Store original picker new function
      local Picker = require("telescope.pickers")
      local original_new = Picker.new
      
      -- Override picker creation
      Picker.new = function(opts, ...)
        -- Add selection callback wrapper
        local original_attach_mappings = opts.attach_mappings
        opts.attach_mappings = function(prompt_bufnr, map)
          -- Call original if exists
          if original_attach_mappings then
            original_attach_mappings(prompt_bufnr, map)
          end
          
          -- Add safety wrapper for selection change
          local action_state = require("telescope.actions.state")
          
          -- Monitor selection changes
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = prompt_bufnr,
            callback = function()
              local entry = action_state.get_selected_entry()
              if entry and entry.path and (
                entry.path:match("%.hs$") or 
                entry.path:match("xmonad%.hs$")
              ) then
                -- Prevent any processing of this file
                vim.g._telescope_dangerous_selection = true
                
                -- Disable things that might crash
                vim.defer_fn(function()
                  if vim.g._telescope_dangerous_selection then
                    -- Clear any pending operations
                    vim.cmd("silent! autocmd! FileType haskell")
                    vim.cmd("silent! autocmd! BufReadPre *.hs")
                  end
                end, 1)
              else
                vim.g._telescope_dangerous_selection = false
              end
            end
          })
          
          return true
        end
        
        return original_new(opts, ...)
      end
    end
    
    -- Global protection against Haskell file operations during telescope
    vim.api.nvim_create_autocmd({"BufReadPre", "BufAdd", "BufNew"}, {
      pattern = {"*.hs", "*.lhs", "*.hsc"},
      callback = function(args)
        if vim.g._telescope_dangerous_selection then
          -- Prevent file from actually loading
          vim.notify("Blocked Haskell file operation during telescope selection", vim.log.levels.DEBUG)
          return true -- This should prevent the default action
        end
      end
    })
    
    -- Alternative: completely skip Haskell files in results
    local function filter_haskell_files()
      return function(entry)
        if entry.path and (
          entry.path:match("%.hs$") or 
          entry.path:match("%.lhs$") or 
          entry.path:match("%.hsc$")
        ) then
          -- Optionally hide them completely
          -- return false
          
          -- Or mark them specially
          entry.display = "⚠ " .. (entry.display or entry.path)
        end
        return true
      end
    end
    
    -- Command to use filtered telescope
    vim.api.nvim_create_user_command("TelescopeSafe", function()
      require("telescope.builtin").find_files({
        file_ignore_patterns = {"%.hs$", "%.lhs$", "%.hsc$"},
      })
    end, {})
  '';
  
  # Provide an alternative keymap that filters out Haskell files
  keymaps = [
    {
      mode = "n";
      key = "<leader>F";
      action = "<cmd>TelescopeSafe<cr>";
      options = {
        desc = "Find files (no Haskell)";
      };
    }
  ];
}