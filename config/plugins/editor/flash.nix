{
  plugins.flash = {
    enable = true;
    settings = {
      labels = "rsthnaio";
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "s";
      action.__raw = "function() require(\"flash\").jump() end";
      options = {
        silent = true;
        desc = "Flash";
      };
    }

    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "S";
      action.__raw = "function() require(\"flash\").treesitter() end";
      options = {
        silent = true;
        desc = "Flash Treesitter";
      };
    }

    {
      mode = "o";
      key = "r";
      action.__raw = "function() require(\"flash\").remote() end";
      options = {
        silent = true;
        desc = "Flash Remote";
      };
    }

    {
      mode = [
        "o"
        "x"
      ];
      key = "R";
      action.__raw = "function() require(\"flash\").treesitter_search() end";
      options = {
        silent = true;
        desc = "Treesitter Search";
      };
    }

    {
      mode = "c";
      key = "<c-s>";
      action.__raw = "function() require(\"flash\").toggle() end";
      options = {
        silent = true;
        desc = "Toggle Flash Search";
      };
    }
  ];
}
