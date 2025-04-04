{
  config,
  lib,
  pkgs,
  ...
}:

{

  extraPlugins = with pkgs.vimPlugins; [
    tiny-inline-diagnostic-nvim
  ];
}
