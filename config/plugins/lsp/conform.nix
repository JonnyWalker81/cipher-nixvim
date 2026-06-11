{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # default_format_opts.lsp_format = "prefer";
      # format_on_save = {
      #   lspFallback = true;
      #   timeoutMs = 500;
      # };
      # format_after_save = {
      #   timeoutMs = 500;
      #   lspFallback = true;
      # };
      format_on_save = ''
        function(bufnr)
            local filetype = vim.bo[bufnr].filetype
            if filetype == "html" then
              return { timeoutMs = 1000, lspFallback = true }
            else
              return { timeoutMs = 500, lspFallback = true }
            end
          end
      '';

      format_after_save = ''
        function(bufnr)
            local filetype = vim.bo[bufnr].filetype
            if filetype ~= "html" then
              return { timeoutMs = 1000, lspFallback = true }
            else
              return { timeoutMs = 500, lspFallback = true }
            end
          end
      '';

      formatters_by_ft = {
        # Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];

        sql = [ "sql_formatter" ];

        # html = {
        #   __unkeyed-1 = "prettierd";
        #   __unkeyed-2 = "prettier";
        #   # timeout_ms = 500;
        #   stop_after_first = true;
        # };

        # typescript = {
        #   __unkeyed-1 = "prettierd";
        #   __unkeyed-2 = "prettier";
        #   stop_after_first = true;
        # };
      };
      formatters = {
        sql_formatter = {
          command = lib.getExe pkgs.sql-formatter;
          prepend_args = [
            "--language"
            "postgresql"
            "--config"
            (builtins.toJSON { useTabs = true; })
          ];
        };
      };
      # formatters = {
      #   _ = {
      #     command = "${pkgs.gawk}/bin/gawk";
      #   };
      #   squeeze_blanks = {
      #     command = lib.getExe' pkgs.coreutils "cat";
      #   };
      #   prettierd.command = lib.getExe pkgs.prettierd;
      #   prettier.command = lib.getExe pkgs.nodePackages.prettier;
      # };
    };
  };

  # Treat Go raw strings that start with a SQL keyword as embedded SQL so
  # conform's "injected" formatter (and treesitter highlighting) can handle them.
  extraFiles."after/queries/go/injections.scm".text =
    let
      sqlKeywords = [
        "WITH"
        "SELECT"
        "INSERT"
        "UPDATE"
        "DELETE"
        "CREATE"
        "ALTER"
        "DROP"
      ];
      mkPattern = kw: ''
        ((raw_string_literal_content) @injection.content
          (#lua-match? @injection.content "^%s*${kw}%s")
          (#set! injection.language "sql"))
      '';
    in
    ''
      ;; extends

      ${lib.concatMapStringsSep "\n" mkPattern sqlKeywords}
    '';

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format()<cr>";
      options = {
        silent = true;
        desc = "Format";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cF";
      action.__raw = ''
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end
      '';
      options = {
        silent = true;
        desc = "Format embedded code (SQL strings etc.)";
      };
    }
  ];
}
