{
  imports = [
    ./theme

    ./ai/copilot.nix
    ./ai/supermaven.nix

    ./completion/blink.nix
    ./completion/cmp.nix
    ./completion/friendly-snippets.nix
    ./completion/lspkind.nix

    ./luasnip

    ./util/mini.nix
    ./util/dadbod.nix

    ./ui/bufferline.nix
    ./ui/lualine.nix
    ./ui/general.nix
    ./ui/alpha.nix
    ./ui/toggleterm.nix
    ./ui/ufo.nix
    ./ui/colorizer.nix

    ./telescope

    ./git/blame.nix
    ./git/gitsigns.nix
    ./git/octo.nix
    ./git/neogit.nix

    ./editor/flash.nix
    ./editor/harpoon.nix
    ./editor/whichkey.nix
    ./editor/yazi.nix
    ./editor/oil.nix
    ./editor/undotree.nix
    ./editor/spider.nix

    ./treesitter/treesitter.nix
    ./treesitter/treesitter-textobjects.nix

    ./lsp/trouble.nix
    ./lsp/lsp.nix
    ./lsp/conform.nix
    ./lsp/lspsaga.nix

    ./lang/go.nix
    ./lang/hcl.nix
    ./lang/json.nix
    ./lang/nix.nix
    ./lang/ocaml.nix
    ./lang/rust.nix
    ./lang/shell.nix
    ./lang/terraform.nix
    ./lang/typescript.nix
    ./lang/yaml.nix
    ./lang/zig.nix
  ];
}
