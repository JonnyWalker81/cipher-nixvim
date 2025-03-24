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
        tf = [
          "terraform_fmt"
        ];
      };
      formatters = {
        terraform_fmt.command = lib.getExe pkgs.terraform;
      };
    };

    none-ls.sources.formatting.terraform_fmt.enable = true;

    lsp.servers.terraformls.enable = true;
  };
}
