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
        formatters_by_ft = {
          yml = [ "yamlfmt" ];
        };
        formatters_by_ft = {
          yaml = [ "yamlfmt" ];
        };
      };
    };
    lsp.servers.yamlls.enable = true;
  };
}
