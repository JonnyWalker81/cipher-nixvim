{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    modus.enable = lib.mkEnableOption "Enable Modus module";
  };

  config = lib.mkIf config.modus.enable {
    colorschemes.modus = {
      enable = true;
      settings = {
        style = "modus_vivendi";
      };
    };
  };
}
