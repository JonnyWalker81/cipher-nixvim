{
  lib,
  config,
  ...
}:
{
  imports = [
    # ./base16.nix
    ./catppuccin.nix
    ./rose-pine.nix
    ./tokyonight.nix
  ];

  options = {
    colorschemes.enable = lib.mkEnableOption "Enable colorschemes module";
  };
  config = lib.mkIf config.colorschemes.enable {
    # base16.enable = lib.mkDefault false;
    # catppuccin.enable = lib.mkDefault true;
    # rose-pine.enable = lib.mkDefault false;
    tokyonight.enable = lib.mkDefault true;
  };

  # colorschemes = {
  #   tokyonight = {
  #     enable = true;
  #     settings = {
  #       style = "night"; # “night”, “day”, “storm”
  #       transparent = true;
  #       styles = {
  #         comments.italic = true;
  #         keywords.italic = true;
  #         functions = { };
  #         variables = { };
  #         sidebars = "dark";
  #         floats = "dark";
  #       };
  #     };
  #   };
  #   catppuccin = {
  #     enable = true;
  #     settings = {
  #       background = {
  #         light = "macchiato";
  #         dark = "mocha";
  #       };
  #       flavour = "macchiato"; # “latte”, “mocha”, “frappe”, “macchiato”, “auto”
  #       transparent_background = true;
  #       integrations = {
  #         cmp = true;
  #         flash = true;
  #         fidget = true;
  #         gitsigns = true;
  #         indent_blankline.enabled = true;
  #         lsp_trouble = true;
  #         mini.enabled = true;
  #         neotree = true;
  #         noice = true;
  #         notify = true;
  #         telescope.enabled = true;
  #         treesitter = true;
  #         treesitter_context = true;
  #         which_key = true;
  #         native_lsp = {
  #           enabled = true;
  #           inlay_hints = {
  #             background = true;
  #           };
  #           virtual_text = {
  #             errors = [ "italic" ];
  #             hints = [ "italic" ];
  #             information = [ "italic" ];
  #             warnings = [ "italic" ];
  #             ok = [ "italic" ];
  #           };
  #           underlines = {
  #             errors = [ "underline" ];
  #             hints = [ "underline" ];
  #             information = [ "underline" ];
  #             warnings = [ "underline" ];
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
