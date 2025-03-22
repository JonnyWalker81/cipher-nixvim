{ pkgs, lib, ... }:
{
  plugins = {
    conform-nvim.settings = {
      formatters_by_ft = {
        zig = [ "zigfmt" ];
      };
      # formatters = {
      #   shfmt.command = lib.getExe pkgs.shfmt;
      # };
    };

    lsp.servers.zls.enable = true;
  };
}
