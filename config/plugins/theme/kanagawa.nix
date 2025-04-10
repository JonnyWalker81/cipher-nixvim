{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    kanagawa.enable = lib.mkEnableOption "Enable Kanagawa module";
  };

  config = lib.mkIf config.kanagawa.enable {
    colorschemes.kanagawa = {
      enable = true;
      settings = {
        background = {
          dark = "wave";
        };
        theme = "wave";
      };
    };
  };
}
