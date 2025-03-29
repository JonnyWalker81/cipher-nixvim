{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft.json = [ "prettier" ];
      };
    };
    # none-ls.sources.formatting.goimports.enable = true;
  };
}
