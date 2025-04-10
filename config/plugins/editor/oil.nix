{ config, lib, ... }:
{
  plugins.oil = {
    enable = true;

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
