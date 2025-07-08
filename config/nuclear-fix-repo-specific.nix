# Nuclear option: Completely different behavior for problematic repos
{ config, lib, ... }:
{
  # Override keybindings for specific directories
  extraConfigLua = ''
    -- Detect problematic repositories and use alternative file finding
    local function is_problematic_repo()
      local cwd = vim.fn.getcwd()
      return cwd:match("nixos%-config") or 
             cwd:match("xmonad") or
             vim.fn.filereadable(cwd .. "/users/xmonad/xmonad.hs") == 1
    end
    
    -- Alternative file finder using vim's built-in
    local function safe_find_files()
      if is_problematic_repo() then
        -- Use vim's wildmenu instead of telescope
        vim.cmd("set wildmenu")
        vim.cmd("set wildmode=longest:full,full")
        vim.cmd("e **/*")
      else
        -- Use normal telescope
        require('telescope.builtin').find_files()
      end
    end
    
    -- Alternative using quickfix list
    local function safe_grep()
      if is_problematic_repo() then
        vim.ui.input({prompt = "Search pattern: "}, function(pattern)
          if pattern then
            vim.cmd("silent! grep! " .. pattern .. " **/*.hs **/*.nix")
            vim.cmd("copen")
          end
        end)
      else
        require('telescope.builtin').live_grep()
      end
    end
    
    -- Override the main keybindings
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if is_problematic_repo() then
          vim.notify("Problematic repo detected - using safe file navigation", vim.log.levels.WARN)
          
          -- Override problematic keybindings
          vim.keymap.set('n', '<leader><leader>', safe_find_files, {desc = "Safe find files"})
          vim.keymap.set('n', '<leader><space>', safe_find_files, {desc = "Safe find files"})
          vim.keymap.set('n', '<leader>/', safe_grep, {desc = "Safe grep"})
          
          -- Disable telescope lazy loading for this session
          vim.g.telescope_disabled = true
          
          -- Also provide fzf-based alternative
          vim.keymap.set('n', '<leader>fz', function()
            vim.fn.system("tmux new-window 'cd " .. vim.fn.getcwd() .. " && fzf | xargs -r nvim'")
          end, {desc = "Open fzf in new tmux window"})
        end
      end
    })
    
    -- Emergency escape hatch
    vim.keymap.set('n', '<leader>XX', function()
      -- Disable ALL file pickers
      vim.g.telescope_disabled = true
      vim.g.snacks_picker_disabled = true
      
      -- Clear any floating windows
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
      
      vim.notify("All pickers disabled - use :e or :find", vim.log.levels.WARN)
    end, {desc = "EMERGENCY: Disable all pickers"})
  '';

  # Add classic vim settings for better :e experience
  settings = {
    path = "**";
    wildmenu = true;
    wildignore = "*.o,*.obj,*~,*.swp,*.DS_Store,.git/**,node_modules/**";
    wildmode = "longest:full,full";
  };
}