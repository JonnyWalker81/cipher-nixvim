{ pkgs, ... }:
{
  imports = [
    ./manix.nix
    ./undo.nix
    ./fzf-lua.nix
  ];

  plugins = {
    telescope = {
      enable = true;
      highlightTheme = "Catppuccin Macchiato";
      
      lazyLoad = {
        enable = true;
        settings = {
          cmd = [ "Telescope" ];
          keys = [
            { __unkeyed-1 = "<leader><space>"; desc = "Find files"; }
            { __unkeyed-1 = "<leader>/"; desc = "Grep search"; }
            { __unkeyed-1 = "<leader>bb"; desc = "Buffers"; }
            { __unkeyed-1 = "<leader>fr"; desc = "Recent files"; }
            { __unkeyed-1 = "<leader>fg"; desc = "Find git files"; }
            { __unkeyed-1 = "<leader>fy"; desc = "Yank history"; }
            { __unkeyed-1 = "<leader>fc"; desc = "Colorscheme"; }
            { __unkeyed-1 = "<leader>fk"; desc = "Keymaps"; }
            { __unkeyed-1 = "<leader>gc"; desc = "Git commits"; }
            { __unkeyed-1 = "<leader>gb"; desc = "Git branches"; }
            { __unkeyed-1 = "<leader>gs"; desc = "Git status"; }
            { __unkeyed-1 = "<leader>gS"; desc = "Git stash"; }
            { __unkeyed-1 = "<leader>ff"; desc = "Find files"; }
            { __unkeyed-1 = "<leader>fg"; desc = "Live grep"; }
            { __unkeyed-1 = "<leader>fb"; desc = "Buffers"; }
            { __unkeyed-1 = "<leader>fh"; desc = "Help tags"; }
            { __unkeyed-1 = "<leader>fd"; desc = "Diagnostics"; }
          ];
        };
      };
      extensions = {
        fzf-native = {
          enable = true;
        };
        ui-select = {
          enable = true;
          settings = {
            __unkeyed-1.__raw = ''require("telescope.themes").get_dropdown{}'';
            specific_opts = {
              codeactions = true;
            };
          };
        };
      };

      settings.defaults = {
        prompt_prefix = "   ";
        color_devicons = true;
        set_env.COLORTERM = "truecolor";
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];

        pickers = {
          colorscheme = {
            enable_preview = true;
          };
          # find_files = {
          #   theme = "ivy";
          # };
        };

        mappings = {
          i = {
            # Have Telescope not to enter a normal-like mode when hitting escape (and instead exiting), you can map <Esc> to do so via:
            "<esc>".__raw = ''
              function(...)
                return require("telescope.actions").close(...)
              end'';
            "<c-t>".__raw = ''
              function(...)
                require('trouble.providers.telescope').open_with_trouble(...);
              end
            '';
          };
          n = {
            "<c-t>".__raw = ''
              function(...)
                require('trouble.providers.telescope').open_with_trouble(...);
              end
            '';
          };
        };
        # trim leading whitespace from grep
        vimgrep_arguments = [
          "${pkgs.ripgrep}/bin/rg"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
          "--trim"
        ];
      };
      keymaps = {
        "<leader>ft" = {
          action = "todo-comments";
          options.desc = "View Todo";
        };
        "<leader><space>" = {
          action = "find_files hidden=true";
          options.desc = "Find project files";
        };
        # Removed - using snacks picker for <leader><leader> now
        "<leader>bb" = {
          action = "buffers";
          options.desc = "Buffers";
        };
        "<leader>/" = {
          action = "live_grep hidden=true";
          options.desc = "Grep (root dir)";
        };
        "<leader>f:" = {
          action = "command_history";
          options.desc = "View Command History";
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "View Recent files";
        };
        "<c-p>" = {
          mode = [
            "n"
            "i"
          ];
          action = "registers";
          options.desc = "Select register to paste";
        };
        "<leader>gc" = {
          action = "git_commits";
          options.desc = "commits";
        };
        "<leader>fa" = {
          action = "autocommands";
          options.desc = "Auto Commands";
        };
        "<leader>fc" = {
          action = "commands";
          options.desc = "View Commands";
        };
        "<leader>fd" = {
          action = "diagnostics bufnr=0";
          options.desc = "View Workspace diagnostics";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "View Help pages";
        };
        "<leader>fk" = {
          action = "keymaps";
          options.desc = "View Key maps";
        };
        "<leader>fm" = {
          action = "man_pages";
          options.desc = "View Man pages";
        };
        "<leader>f'" = {
          action = "marks";
          options.desc = "View Marks";
        };
        "<leader>fo" = {
          action = "vim_options";
          options.desc = "View Options";
        };
        "<leader>uC" = {
          action = "colorscheme";
          options.desc = "Colorscheme preview";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = ''
        function()
              require('telescope.builtin').live_grep {
                hidden = true,
                cwd = vim.fn.expand('%:p:h')
              }
            end
      '';
      options = {
        desc = "[S]earch Files in Current Directory";
      };
    }
    {
      mode = "n";
      key = "<leader>:";
      action = "<cmd>Telescope commands<cr>";
      options = {
        desc = "Commands";
      };
    }
    # {
    #   mode = "n";
    #   key = "gD";
    #   action = "<cmd>lua require('telescope.builtin').lsp_references{}<cr>";
    #   options = {
    #     desc = "Lsp References";
    #   };
    # }
  ];
}
