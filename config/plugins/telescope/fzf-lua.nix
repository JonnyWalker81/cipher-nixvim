{ config, lib, ... }:
{
  plugins.fzf-lua = {
    enable = true;
    
    # Use icons from the icon system
    settings = {
      # General settings
      winopts = {
        height = 0.85;
        width = 0.80;
        row = 0.35;
        col = 0.50;
        border = "rounded";
        preview = {
          border = "border";
          wrap = "nowrap";
          hidden = "nohidden";
          vertical = "down:45%";
          horizontal = "right:50%";
          layout = "flex";
          flip_columns = 120;
          scrollbar = "float";
          scrolloff = "-2";
          default = "bat";
        };
      };
      
      # File and text search options
      files = {
        prompt = "Files❯ ";
        multiprocess = true;
        git_icons = true;
        file_icons = true;
        color_icons = true;
        cmd = "fd --type f --hidden --follow --exclude .git";
      };
      
      grep = {
        prompt = "Rg❯ ";
        input_prompt = "Grep For❯ ";
        multiprocess = true;
        git_icons = true;
        file_icons = true;
        color_icons = true;
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e";
      };
      
      # LSP settings
      lsp = {
        prompt_postfix = "❯ ";
        cwd_only = false;
        async_or_timeout = 5000;
        file_icons = true;
        git_icons = false;
      };
      
      # Git settings
      git = {
        files = {
          prompt = "Git Files❯ ";
          cmd = "git ls-files --exclude-standard";
          multiprocess = true;
          git_icons = true;
          file_icons = true;
          color_icons = true;
        };
        status = {
          prompt = "Git Status❯ ";
          cmd = "git -c color.status=false status -s --untracked-files=all";
          file_icons = true;
          git_icons = true;
          color_icons = true;
        };
        commits = {
          prompt = "Git Commits❯ ";
          cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'";
        };
        branches = {
          prompt = "Git Branches❯ ";
          cmd = "git branch --all --color";
        };
      };
      
      # Buffers
      buffers = {
        prompt = "Buffers❯ ";
        file_icons = true;
        color_icons = true;
        git_icons = false;
        sort_lastused = true;
      };
      
      # Oldfiles
      oldfiles = {
        prompt = "History❯ ";
        include_current_session = false;
        cwd_only = false;
      };
      
      # Colorschemes
      colorschemes = {
        prompt = "Colorschemes❯ ";
        live_preview = true;
        winopts = { height = 0.55; width = 0.30; };
      };
      
      # Help tags
      helptags = {
        prompt = "Help❯ ";
        winopts = { preview = { hidden = "nohidden"; }; };
      };
      
      # Keymaps  
      keymap = {
        builtin = {
          # Movement
          __unkeyed-1 = "down:ctrl-j";
          __unkeyed-2 = "up:ctrl-k";
          __unkeyed-3 = "down:ctrl-n";
          __unkeyed-4 = "up:ctrl-p";
          __unkeyed-5 = "bs:ctrl-h";
          __unkeyed-6 = "preview-page-down:ctrl-f";
          __unkeyed-7 = "preview-page-up:ctrl-b";
          __unkeyed-8 = "preview-down:alt-j";
          __unkeyed-9 = "preview-up:alt-k";
        };
        fzf = {
          # fzf bindings
          __unkeyed-1 = "ctrl-z:abort";
          __unkeyed-2 = "ctrl-u:unix-line-discard";
          __unkeyed-3 = "ctrl-a:beginning-of-line";
          __unkeyed-4 = "ctrl-e:end-of-line";
          __unkeyed-5 = "alt-a:toggle-all";
          __unkeyed-6 = "ctrl-d:half-page-down";
          __unkeyed-7 = "ctrl-u:half-page-up";
        };
      };
      
      # Actions
      actions = {
        files = {
          __unkeyed-1 = "default:edit";
          __unkeyed-2 = "ctrl-s:split";
          __unkeyed-3 = "ctrl-v:vsplit";
          __unkeyed-4 = "ctrl-t:tab drop";
        };
        buffers = {
          __unkeyed-1 = "default:edit";
          __unkeyed-2 = "ctrl-s:split";
          __unkeyed-3 = "ctrl-v:vsplit";
          __unkeyed-4 = "ctrl-t:tab drop";
          __unkeyed-5 = "ctrl-x:delete_buf";
        };
      };
      
      # Default options passed to all providers
      defaults = {
        git_icons = true;
        file_icons = true;
        color_icons = true;
      };
    };
    
    # No keymaps defined here - users can call fzf-lua functions manually
    # or define their own keybindings as needed
  };
}