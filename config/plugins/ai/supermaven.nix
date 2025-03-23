{
  config,
  lib,
  pkgs,
  ...
}:

{
  extraPlugins = with pkgs.vimPlugins; [
    supermaven-nvim
  ];
  extraConfigLua = ''
    require('supermaven-nvim').setup({
      keymaps = {
        accept_suggestion = "<C-y>",
        clear_suggestion = "<C-{>",
        accept_word = "<C-w>",
      }
    })
  '';

}
