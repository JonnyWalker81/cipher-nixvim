{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins.spider = {
    enable = true;
  };

  keymaps = [
    {
      mode = [
        "n"
        "o"
        "x"
      ];
      key = "w";
      action = "<cmd>lua require('spider').motion('w')<CR>";
      options = {
        desc = "Spider w";
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "o"
        "x"
      ];
      key = "e";
      action = "<cmd>lua require('spider').motion('e')<CR>";
      options = {
        desc = "Spider e";
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "o"
        "x"
      ];
      key = "b";
      action = "<cmd>lua require('spider').motion('b')<CR>";
      options = {
        desc = "Spider b";
        silent = true;
      };
    }
  ];
}
