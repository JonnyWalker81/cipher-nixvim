{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;

      servers.typos_lsp = {
        enable = true;
        extraOptions = {
          init_options.diagnosticSeverity = "Hint";
        };
      };

      keymaps.lspBuf = {
        # "<c-k>" = "signature_help";
        "gi" = "implementation";
      };
    };
    lint.enable = true;

    lsp-signature.enable = true;
    lsp-lines.enable = true;

    lsp-format.enable = false;

    lsp.servers = {
      ts_ls = {
        enable = true;
        autostart = true;
        filetypes = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
        ];
        extraOptions = {
          settings = {
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayVariableTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
              };
            };
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
                includeInlayFunctionParameterTypeHints = true;
                includeInlayParameterNameHints = "all";
                includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayVariableTypeHints = true;
                includeInlayVariableTypeHintsWhenTypeMatchesName = true;
              };
            };
          };
        };
      };
      eslint = {
        enable = true;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>LspInfo<cr>";
      options.desc = "Lsp Info";
    }
    {
      mode = "n";
      key = "<leader>lf";
      action = ":lua vim.lsp.buf.format()<CR>";
      #    lua = true;
      options = {
        silent = true;
        desc = "Format";
      };
    }
  ];
}
