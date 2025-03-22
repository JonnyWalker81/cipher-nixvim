{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft.go = [ "goimports" ];
      };
    };
    lsp.servers.gopls.enable = true;
    none-ls.sources.formatting.golines.enable = true;
  };
}
