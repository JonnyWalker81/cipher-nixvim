{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins.attempt = {
    enable = true;
  };
}
