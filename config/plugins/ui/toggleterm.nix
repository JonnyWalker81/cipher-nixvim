{ config, lib, ... }:
{
  plugins.toggleterm = {
    enable = true;
    settings = {
      size = ''
        function(term)
          if term.direction == "horizontal" then
            return 30
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end
      '';
      open_mapping = "[[<C-/>]]";
      hide_numbers = true;
      shade_terminals = true;
      start_in_insert = true;
      terminal_mappings = true;
      persist_mode = true;
      insert_mappings = true;
      close_on_exit = true;
      shell = "zsh";
      direction = "horizontal"; # 'vertical' | 'horizontal' | 'tab' | 'float'
      float_opts = {
        border = "single"; # 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        width = 80;
        height = 20;
        winblend = 0;
      };
    };
  };

  keymaps = lib.mkIf config.plugins.toggleterm.enable [
    {
      mode = [
        "t"
        "n"
      ];
      key = "<C-g>";
      action = "<cmd>2ToggleTerm<cr>";
      options.desc = "Open/Close Terminal 2";
    }
    {
      mode = [
        "t"
        "n"
      ];
      key = "<M-Left>";
      action = "<cmd>wincmd h<cr>";
      options.desc = "Go to Left window";
    }
    {
      mode = [
        "t"
        "n"
      ];
      key = "<M-Right>";
      action = "<cmd>wincmd l<cr>";
      options.desc = "Go to Right window";
    }
    {
      mode = [
        "t"
        "n"
      ];
      key = "<M-Up>";
      action = "<cmd>wincmd k<cr>";
      options.desc = "Go to Up window";
    }
    {
      mode = [
        "t"
        "n"
      ];
      key = "<M-Down>";
      action = "<cmd>wincmd j<cr>";
      options.desc = "Go to Down window";
    }
    
    # Add Ctrl+hjkl navigation in terminal mode
    {
      mode = "t";
      key = "<C-h>";
      action = "<C-\\><C-n><C-w>h";
      options.desc = "Go to Left window from terminal";
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<C-\\><C-n><C-w>j";
      options.desc = "Go to Down window from terminal";
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<C-\\><C-n><C-w>k";
      options.desc = "Go to Up window from terminal";
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<C-\\><C-n><C-w>l";
      options.desc = "Go to Right window from terminal";
    }
  ];
}
