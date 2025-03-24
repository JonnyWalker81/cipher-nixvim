{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins = {
    conform-nvim.settings = {
      formatters_by_ft = {
        hcl = [ "hclfmt" ];
      };
      formatters = {
        hclfmt.command = lib.getExe pkgs.hclfmt;
      };
    };

    lsp.servers.terraformls.enable = true;
  };
}
