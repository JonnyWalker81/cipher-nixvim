{
  plugins.lspkind = {
    # Disabled because blink-cmp is being used instead of nvim-cmp
    # and lspkind conflicts when CMP is partially enabled (e.g. cmp-calc)
    enable = false;

    # CMP integration disabled since cmp plugin is disabled
    # cmp.menu = {
    #   nvim_lsp = "";
    #   nvim_lua = "";
    #   neorg = "[neorg]";
    #   buffer = "";
    #   calc = "";
    #   git = "";
    #   luasnip = "󰩫";
    #   codeium = "󱜙";
    #   copilot = "";
    #   emoji = "󰞅";
    #   path = "";
    #   spell = "";
    # };

    settings = {
      symbol_map = {
        Namespace = "󰌗";
        Text = "󰊄";
        Method = "󰆧";
        Function = "󰡱";
        Constructor = "";
        Field = "󰜢";
        Variable = "󰀫";
        Class = "󰠱";
        Interface = "";
        Module = "󰕳";
        Property = "";
        Unit = "󰑭";
        Value = "󰎠";
        Enum = "";
        Keyword = "󰌋";
        Snippet = "";
        Color = "󰏘";
        File = "󰈚";
        Reference = "󰈇";
        Folder = "󰉋";
        EnumMember = "";
        Constant = "󰏿";
        Struct = "󰙅";
        Event = "";
        Operator = "󰆕";
        TypeParameter = "";
        Table = "";
        Object = "󰅩";
        Tag = "";
        Array = "[]";
        Boolean = "";
        Number = "";
        Null = "󰟢";
        String = "󰉿";
        Calendar = "";
        Watch = "󰥔";
        Package = "";
        Copilot = "";
        Codeium = "";
        TabNine = "";
      };
      maxwidth = 50;
      ellipsis_char = "...";
    };
  };
}