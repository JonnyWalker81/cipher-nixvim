{ pkgs, lib, ... }:
{
  plugins = lib.mkIf pkgs.stdenv.isLinux {
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
