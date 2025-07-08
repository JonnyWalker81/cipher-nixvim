{ config, lib, ... }:
{
  plugins.oil = {
    enable = true;
    
    lazyLoad = {
      enable = true;
      settings = {
        cmd = [ "Oil" ];
        keys = [
          { __unkeyed-1 = "<leader>ff"; desc = "File explorer"; }
          { __unkeyed-1 = "-"; desc = "Parent directory"; }
        ];
      };
    };

    settings = {
      view_options = {
        show_hidden = true;
      };
      keymaps = {
        "q" = "actions.close";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Oil<cr>";
      options = {
        desc = "Oil";
        silent = true;
      };
    }
  ];
}
