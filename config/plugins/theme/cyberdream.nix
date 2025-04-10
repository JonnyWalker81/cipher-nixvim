{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    cyberdream.enable = lib.mkEnableOption "Enable Cyberdream module";
  };

  config = lib.mkIf config.cyberdream.enable {
    colorschemes.cyberdream = {
      enable = true;
      # settings = {
      #   background = {
      #     dark = "wave";
      #   };
      #   theme = "wave";
      # };
    };
  };
}
