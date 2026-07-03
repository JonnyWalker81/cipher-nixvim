# Simple fix to disable Haskell support and prevent crashes
{ lib, ... }:
{
  # Disable Haskell in treesitter (nvim-treesitter 1.0+ native option; the
  # legacy settings.highlight.disable function is ignored on the main branch).
  # Large-file handling lives in plugins/treesitter/treesitter.nix.
  plugins.treesitter.highlight.disable = [ "haskell" ];

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