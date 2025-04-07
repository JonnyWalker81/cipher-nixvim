{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    vim-wordmotion
  ];
}
