{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    nightfox.enable = lib.mkEnableOption "Enable Nightfox module";
  };

  config = lib.mkIf config.nightfox.enable {
    colorschemes.nightfox = {
      enable = true;
      flavor = "carbonfox";
    };
  };
}
