# Fix for malloc crash when previewing Haskell files
# Keeps preview enabled but disables treesitter for Haskell files in preview buffers
{ config, lib, ... }:
{
  # Custom telescope configuration to handle Haskell previews safely
  plugins.telescope.settings = {
    defaults = {
      buffer_previewer_maker.__raw = ''
        function(filepath, bufnr, opts)
          opts = opts or {}
          filepath = vim.fn.expand(filepath)
          
          -- Check if it's a Haskell file
          local is_haskell = filepath:match("%.hs$") or 
                            filepath:match("%.lhs$") or 
                            filepath:match("%.hsc$")
          
          -- Use the default previewer but with modifications for Haskell
          if is_haskell then
            -- Schedule the buffer setup to ensure it runs after the file is loaded
            vim.schedule(function()
              vim.api.nvim_buf_call(bufnr, function()
                -- Disable treesitter for this buffer
                local ok = pcall(vim.cmd, "TSBufDisable highlight")
                if ok then
                  vim.cmd("TSBufDisable indent")
                  vim.cmd("TSBufDisable incremental_selection") 
                  vim.cmd("TSBufDisable fold")
                end
                
                -- Set buffer-local variable to prevent treesitter re-enabling
                vim.b[bufnr].ts_highlight = false
                
                -- Optional: Use basic syntax highlighting
                vim.bo[bufnr].syntax = "haskell"
                
                -- Ensure the buffer is marked as nomodifiable in preview
                vim.bo[bufnr].modifiable = false
                vim.bo[bufnr].readonly = true
              end)
            end)
          end
          
          -- Call the default buffer previewer maker
          require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
        end
      '';
      
      -- Keep file size limits for safety
      preview = {
        filesize_limit = 0.5;  -- MB
      };
    };
    
    -- Remove the complete preview disable
    pickers = {
      find_files = {
        previewer.__raw = ''require("telescope.config").values.file_previewer'';
      };
    };
  };

  # Alternative approach using autocommands
  extraConfigLua = ''
    -- Disable treesitter in telescope preview buffers for Haskell
    vim.api.nvim_create_autocmd({"BufReadPre", "BufRead"}, {
      callback = function(args)
        local bufnr = args.buf
        local filename = vim.api.nvim_buf_get_name(bufnr)
        
        -- Check if it's a Haskell file
        if filename:match("%.hs$") or filename:match("%.lhs$") or filename:match("%.hsc$") then
          -- Check if this is a preview buffer (floating window or special buffer)
          local wins = vim.api.nvim_list_wins()
          for _, win in ipairs(wins) do
            if vim.api.nvim_win_get_buf(win) == bufnr then
              local config = vim.api.nvim_win_get_config(win)
              if config.relative ~= "" or vim.bo[bufnr].buftype == "nofile" then
                -- This is likely a preview buffer
                vim.schedule(function()
                  if vim.api.nvim_buf_is_valid(bufnr) then
                    -- Disable treesitter
                    pcall(vim.cmd, string.format("lua vim.treesitter.stop(%d)", bufnr))
                    
                    -- Set buffer options
                    vim.bo[bufnr].syntax = "haskell"
                    vim.b[bufnr].ts_highlight = false
                  end
                end)
                break
              end
            end
          end
        end
      end
    })
    
    -- Additional safety: disable treesitter for Haskell in any floating window
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "haskell",
      callback = function(args)
        local win = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(win)
        
        -- If it's a floating window (preview), disable treesitter
        if config.relative ~= "" then
          vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(win) then
              vim.treesitter.stop(args.buf)
              vim.bo[args.buf].syntax = "haskell"
            end
          end, 10)
        end
      end
    })
  '';
}