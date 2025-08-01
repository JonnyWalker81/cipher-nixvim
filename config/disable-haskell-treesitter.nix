# Temporary fix to disable Haskell treesitter parser
# This might be causing the crash when indexing xmonad.hs
{ ... }:
{
  plugins.treesitter = {
    settings = {
      ensure_installed = builtins.filter (lang: lang != "haskell") 
        (config.plugins.treesitter.settings.ensure_installed or []);
      
      # Disable Haskell highlighting
      highlight.disable = [ "haskell" ];
    };
  };
  
  # Alternative: disable treesitter for .hs files
  extraConfigLua = ''
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      pattern = "*.hs",
      callback = function()
        vim.cmd("TSBufDisable highlight")
        vim.cmd("TSBufDisable indent")
      end
    })
  '';
}