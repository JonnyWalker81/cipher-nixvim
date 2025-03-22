{ config, lib, ... }:
{
  plugins.oil = {
    enable = true;

    settings = {
      view_options = {
        show_hidden = true;
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
