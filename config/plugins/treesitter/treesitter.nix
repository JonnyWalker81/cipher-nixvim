{ config, lib, ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      folding.enable = true;

      settings = {
        highlight = {
          additional_vim_regex_highlighting = false; # Disable for performance
          enable = true;
        };

        incremental_selection.enable = true;
        indent.enable = true;
      };
      nixvimInjections = true;
    };

    treesitter-context = {
      inherit (config.plugins.treesitter) enable;
      settings = {
        max_lines = 4;
        min_window_height = 40;
        multiwindow = true;
        separator = "-";
      };
    };

    # Disabled: nvim-treesitter-refactor is incompatible with nvim-treesitter 1.0+
    # It uses the old nvim-treesitter.query API which no longer exists
    # treesitter-refactor = {
    #   inherit (config.plugins.treesitter) enable;
    #   settings = {
    #     highlight_definitions = {
    #       enable = false;
    #       clear_on_cursor_move = false;
    #     };
    #     smart_rename.enable = true;
    #     navigation.enable = true;
    #   };
    # };
  };

  # Perf guard: don't treesitter-highlight very large buffers. The legacy
  # function form of settings.highlight.disable is ignored by nvim-treesitter
  # 1.0+ (main branch), so this is done with an autocmd instead. Scheduled so
  # it runs after nixvim's own FileType autocmd has started highlighting.
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if vim.api.nvim_buf_line_count(args.buf) > 10000 then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              pcall(vim.treesitter.stop, args.buf)
            end
          end)
        end
      end,
    })
  '';

  keymaps = lib.mkIf config.plugins.treesitter-context.enable [
    {
      mode = "n";
      key = "<leader>uT";
      action = "<cmd>TSContextToggle<cr>";
      options.desc = "Treesitter Context toggle";
    }
  ];
}
