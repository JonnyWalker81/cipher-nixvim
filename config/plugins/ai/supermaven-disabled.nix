{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Supermaven disabled due to binary fetch/JSON decode errors
  # To re-enable, rename this file back to supermaven.nix and remove the comment
  
  # extraPlugins = with pkgs.vimPlugins; [
  #   supermaven-nvim
  # ];
  # extraConfigLua = ''
  #   require('supermaven-nvim').setup({
  #     keymaps = {
  #       accept_suggestion = "<C-y>",
  #       clear_suggestion = "<C-{>",
  #       accept_word = "<C-w>",
  #     }
  #   })
  # '';
}