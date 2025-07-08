# Simple fix to disable Haskell support and prevent crashes
{ lib, ... }:
{
  # Disable Haskell in treesitter by modifying the disable function
  plugins.treesitter.settings.highlight.disable = lib.mkForce ''
    function(lang, bufnr)
      -- Always disable for Haskell to prevent crashes
      if lang == "haskell" then
        return true
      end
      -- Keep existing logic for large files
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end
  '';

  # Force Haskell files to open as text
  extraConfigLua = ''
    -- Override Haskell filetype detection
    vim.filetype.add({
      extension = {
        hs = "text",
        lhs = "text",
        hsc = "text",
      },
    })
    
    -- Prevent any Haskell processing
    vim.api.nvim_create_autocmd({"BufReadPre", "BufNewFile"}, {
      pattern = {"*.hs", "*.lhs", "*.hsc"},
      callback = function(args)
        -- Force plain text
        vim.bo[args.buf].filetype = "text"
        vim.bo[args.buf].syntax = ""
        
        -- Show warning
        vim.schedule(function()
          vim.notify("Haskell support disabled to prevent crashes", vim.log.levels.WARN)
        end)
      end
    })
  '';
}