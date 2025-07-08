# Fix for malloc crash when previewing Haskell files
# Disables preview for Haskell files in both telescope and snacks
{ config, lib, ... }:
{
  # Disable preview for Haskell files in telescope
  plugins.telescope.settings = {
    defaults = {
      # Disable preview for specific file types
      preview = {
        filesize_hook = ''
          function(filepath, bufnr, opts)
            -- Disable preview for Haskell files
            if vim.fn.fnamemodify(filepath, ':e') == 'hs' then
              return false
            end
            -- Also disable for large files
            local stats = vim.loop.fs_stat(filepath)
            if stats and stats.size > 100000 then
              return false
            end
            return true
          end
        '';
      };
      
      # Alternative: Set specific previewers
      file_previewer.__raw = ''
        function(filepath, bufnr, opts)
          -- Skip preview for Haskell files
          if filepath:match("%.hs$") then
            return require("telescope.previewers").new_buffer_previewer({
              define_preview = function(self, entry)
                vim.api.nvim_buf_set_lines(
                  self.state.bufnr,
                  0,
                  -1,
                  false,
                  {"Haskell preview disabled to prevent crashes"}
                )
              end
            })
          end
          -- Use default previewer for other files
          return require("telescope.previewers").vim_buffer_cat.new(opts)
        end
      '';
    };
    
    pickers = {
      find_files = {
        # Disable preview completely for find_files if needed
        previewer = false;  # Set to false to disable preview entirely
      };
    };
  };

  # For snacks picker (if re-enabled)
  plugins.snacks.settings.picker = {
    # Disable preview for Haskell files
    preview = {
      # Don't preview files matching these patterns
      ignore_patterns = [ "*.hs" "*.lhs" "*.hsc" ];
    };
  };

  # Global fix: Disable treesitter for Haskell files in preview windows
  extraConfigLua = ''
    -- Disable treesitter in preview windows for Haskell files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "haskell",
      callback = function(args)
        local win = vim.api.nvim_get_current_win()
        local win_config = vim.api.nvim_win_get_config(win)
        
        -- Check if this is a floating/preview window
        if win_config.relative ~= "" or vim.bo[args.buf].buftype == "nofile" then
          -- Disable treesitter in preview windows
          vim.cmd("TSBufDisable highlight")
          vim.cmd("TSBufDisable indent")
          vim.cmd("TSBufDisable incremental_selection")
          vim.cmd("TSBufDisable fold")
          
          -- Also disable other potentially problematic features
          vim.bo[args.buf].syntax = "off"
          vim.bo[args.buf].filetype = ""
        end
      end
    })
    
    -- Alternative: Completely disable preview for telescope when in Haskell projects
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        local cwd = vim.fn.getcwd()
        -- Check if we're in a Haskell project
        if vim.fn.filereadable(cwd .. "/stack.yaml") == 1 or 
           vim.fn.filereadable(cwd .. "/cabal.project") == 1 or
           vim.fn.glob(cwd .. "/*.cabal") ~= "" then
          -- Disable telescope preview in Haskell projects
          require("telescope").setup({
            defaults = {
              preview = false
            }
          })
          print("Telescope preview disabled in Haskell project")
        end
      end
    })
  '';
}