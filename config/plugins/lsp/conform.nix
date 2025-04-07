{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # format_on_save = {
      #   lspFallback = true;
      #   timeoutMs = 500;
      # };
      format_after_save = {
        timeoutMs = 500;
        lspFallback = true;
      };
      formatters_by_ft = {
        # Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];
        html = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
      };
      formatters = {
        _ = {
          command = "${pkgs.gawk}/bin/gawk";
        };
        squeeze_blanks = {
          command = lib.getExe' pkgs.coreutils "cat";
        };
        prettierd.command = lib.getExe pkgs.prettierd;
        prettier.command = lib.getExe pkgs.nodePackages.prettier;
      };
    };
  };

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
  ];
}
