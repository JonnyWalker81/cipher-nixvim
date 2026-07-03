{ pkgs, lib, ... }:
{
  plugins = {
    conform-nvim.settings = {
      formatters_by_ft = {
        odin = [ "odinfmt" ];
      };
      formatters = {
        odinfmt.command = lib.getExe' pkgs.ols "odinfmt";
      };
    };

    lsp.servers.ols.enable = true;
  };
}
