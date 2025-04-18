{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins.none-ls = {
    enable = true;
    settings = {
      cmd = [ "bash -c nvim" ];
      debug = true;
    };
    sources = {
      code_actions = {
        statix.enable = true;
      };
      diagnostics = {
        statix.enable = true;
        deadnix.enable = true;
      };
      formatting = {
        terraform_fmt.enable = true;
        goimports.enable = true;
        # alejandra.enable = true;
        # stylua.enable = true;
        # shfmt.enable = true;
        # nixpkgs_fmt.enable = true;
        # prettier = {
        #   enable = true;
        #   disableTsServerFormatter = true;
        # };
        # black.enable = true;
      };
    };
  };
}
