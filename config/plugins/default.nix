{
  imports = [
    ./theme

    ./ai/copilot.nix

    ./completion/blink.nix
    ./completion/cmp.nix
    ./completion/friendly-snippets.nix
    ./completion/lspkind.nix

    ./luasnip

    ./util/mini.nix

    ./ui/bufferline.nix
    ./ui/lualine.nix
    ./ui/general.nix
    ./ui/alpha.nix
    ./ui/toggleterm.nix
    ./ui/ufo.nix
    ./ui/colorizer.nix

    ./telescope

    ./git/gitsigns.nix

    ./editor/whichkey.nix
    ./editor/yazi.nix

    ./lsp/trouble.nix
    ./lsp/lsp.nix
    ./lsp/conform.nix
    ./lsp/lspsaga.nix

    ./lang/go.nix
  ];
}
