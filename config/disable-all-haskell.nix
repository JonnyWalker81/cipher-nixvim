# Completely disable all Haskell support to prevent crashes
{ config, lib, pkgs, ... }:
{
  # Disable Haskell in treesitter
  plugins.treesitter.settings = {
    # Disable highlighting for Haskell - merge with existing function
    highlight.disable = lib.mkForce ''
      function(lang, bufnr)
        -- Always disable for Haskell
        if lang == "haskell" then
          return true
        end
        -- Keep existing logic for large files
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end
    '';
    
    # Disable all treesitter modules for Haskell
    indent.disable = ["haskell"];
    incremental_selection.disable = ["haskell"];
  };

  # Prevent Haskell filetype from being set
  extraConfigLuaPre = ''
    -- Completely disable Haskell filetype detection
    vim.g.did_load_haskell_ftplugin = 1
    vim.g.did_load_haskell_syntax = 1
    
    -- Override filetype detection for Haskell files
    vim.filetype.add({
      extension = {
        hs = "text",
        lhs = "text", 
        hsc = "text",
      },
      filename = {
        ["*.hs"] = "text",
        ["*.lhs"] = "text",
        ["*.hsc"] = "text",
      },
    })
  '';

  # Disable Haskell-related features
  extraConfigLua = ''
    -- Prevent any Haskell filetype plugins from loading
    vim.api.nvim_create_autocmd("BufReadPre", {
      pattern = {"*.hs", "*.lhs", "*.hsc"},
      callback = function(args)
        -- Force filetype to text
        vim.bo[args.buf].filetype = "text"
        -- Disable syntax
        vim.bo[args.buf].syntax = "OFF"
        -- Prevent treesitter from attaching
        vim.b[args.buf].ts_highlight = false
        
        -- Notify user
        vim.schedule(function()
          vim.notify("Haskell support disabled to prevent crashes. File opened as plain text.", vim.log.levels.WARN)
        end)
      end
    })
    
    -- Ensure treesitter never tries to parse Haskell
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "haskell",
      callback = function()
        -- This should never trigger, but if it does, immediately change it
        vim.bo.filetype = "text"
        return true
      end
    })
    
    -- Disable Haskell treesitter using the built-in vim.treesitter API
    -- This prevents any treesitter features from activating for Haskell
    vim.treesitter.language.register("text", "haskell")
    
    -- Create safe command to view Haskell files
    vim.api.nvim_create_user_command("SafeHaskell", function(opts)
      local file = opts.args
      if file == "" then
        file = vim.fn.expand("%")
      end
      
      -- Open in a new buffer with all safety measures
      vim.cmd("enew")
      vim.bo.filetype = "text"
      vim.bo.syntax = "OFF"
      vim.b.ts_highlight = false
      
      -- Read the file content
      local lines = vim.fn.readfile(file)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.api.nvim_buf_set_name(0, file .. " [SAFE MODE]")
      vim.bo.modified = false
      vim.bo.modifiable = true
    end, {
      nargs = "?",
      complete = "file",
      desc = "Open Haskell file in safe mode"
    })
  '';

  # Remove any Haskell-specific keybindings
  keymaps = lib.mkAfter (
    builtins.filter (keymap: 
      let
        action = keymap.action or "";
        hasHaskell = builtins.match ".*[Hh]askell.*" action;
      in
        hasHaskell == null
    ) (config.keymaps or [])
  );
}