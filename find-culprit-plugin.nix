# Diagnostic configuration to find which plugin causes the crash
# This disables groups of plugins to isolate the issue
{ config, lib, ... }:
let
  # Set this to test different configurations
  testMode = "disable-lsp"; # Options: "baseline", "disable-lsp", "disable-git", "disable-ui", "disable-treesitter"
in
{
  # Baseline: Disable most features that could interfere with file selection
  plugins = lib.mkIf (testMode == "baseline") {
    # Disable all potentially problematic plugins
    lsp.enable = false;
    treesitter.enable = false;
    gitsigns.enable = false;
    lualine.enable = false;
    bufferline.enable = false;
    nvim-colorizer.enable = false;
    indent-blankline.enable = false;
    mini.enable = false;
    
    # Keep only telescope
    telescope.enable = true;
  };

  # Test 1: Disable LSP and language features
  plugins.lsp.enable = lib.mkIf (testMode == "disable-lsp") false;
  plugins.lspkind.enable = lib.mkIf (testMode == "disable-lsp") false;
  plugins.lsp-format.enable = lib.mkIf (testMode == "disable-lsp") false;
  plugins.trouble.enable = lib.mkIf (testMode == "disable-lsp") false;
  
  # Test 2: Disable Git integration
  plugins.gitsigns.enable = lib.mkIf (testMode == "disable-git") false;
  plugins.neogit.enable = lib.mkIf (testMode == "disable-git") false;
  plugins.octo.enable = lib.mkIf (testMode == "disable-git") false;
  
  # Test 3: Disable UI enhancements
  plugins.lualine.enable = lib.mkIf (testMode == "disable-ui") false;
  plugins.bufferline.enable = lib.mkIf (testMode == "disable-ui") false;
  plugins.nvim-colorizer.enable = lib.mkIf (testMode == "disable-ui") false;
  plugins.indent-blankline.enable = lib.mkIf (testMode == "disable-ui") false;
  
  # Test 4: Disable treesitter completely
  plugins.treesitter = lib.mkIf (testMode == "disable-treesitter") {
    enable = false;
    nixGrammars = false;
  };

  # Add diagnostic info
  extraConfigLua = ''
    -- Show which test mode is active
    vim.notify("Diagnostic mode: ${testMode}", vim.log.levels.WARN)
    
    -- Log when files are accessed
    local orig_bufadd = vim.fn.bufadd
    vim.fn.bufadd = function(name)
      if name:match("xmon") then
        vim.notify("bufadd called with: " .. name, vim.log.levels.WARN)
      end
      return orig_bufadd(name)
    end
    
    -- Track what's trying to load files
    local orig_filereadable = vim.fn.filereadable  
    vim.fn.filereadable = function(path)
      if path:match("xmon") then
        vim.notify("filereadable check: " .. path, vim.log.levels.INFO)
        vim.notify("Stack trace: " .. debug.traceback(), vim.log.levels.DEBUG)
      end
      return orig_filereadable(path)
    end
  '';
}