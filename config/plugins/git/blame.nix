{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins.gitblame = {
    enable = true;
  };
}
