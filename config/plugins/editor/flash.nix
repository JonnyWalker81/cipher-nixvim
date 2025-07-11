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
      action = "function() require(\"flash\").jump() end";
      lua = true;
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
      action = "function() require(\"flash\").treesitter() end";
      lua = true;
      options = {
        silent = true;
        desc = "Flash Treesitter";
      };
    }

    {
      mode = "o";
      key = "r";
      action = "function() require(\"flash\").remote() end";

      lua = true;
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
      action = "function() require(\"flash\").treesitter_search() end";

      lua = true;
      options = {
        silent = true;
        desc = "Treesitter Search";
      };
    }

    {
      mode = "c";
      key = "<c-s>";
      action = "function() require(\"flash\").toggle() end";

      lua = true;
      options = {
        silent = true;
        desc = "Toggle Flash Search";
      };
    }
  ];
}
