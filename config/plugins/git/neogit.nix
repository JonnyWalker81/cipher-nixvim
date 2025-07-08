{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins = {
    neogit = {
      enable = true;
      
      lazyLoad = {
        enable = true;
        settings = {
          cmd = [ "Neogit" ];
          keys = [
            { __unkeyed-1 = "<leader>gg"; desc = "Neogit"; }
          ];
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action = ":Neogit<CR>";
      #    lua = true;
      options = {
        silent = true;
        desc = "Neogit";
      };
    }
  ];
}
