{ pkgs, lib, ... }:
{
  plugins = {
    conform-nvim.settings = {
      formatters_by_ft = {
        ocaml = [ "ocamlformat" ];
      };
      # formatters = {
      #   shfmt.command = lib.getExe pkgs.shfmt;
      # };
    };

    lsp.servers.ocamllsp.enable = true;
  };
}
