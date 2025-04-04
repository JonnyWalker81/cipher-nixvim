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

  extraConfigLua = ''
    require('gitblame').toggle()
  '';
}
