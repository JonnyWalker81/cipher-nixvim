{ config, lib, ... }:
{
  plugins.overseer = {
    enable = true;
    settings = {
      strategy = "terminal";
      templates = [ "builtin" ];
      task_list = {
        direction = "bottom";
        min_height = 10;
        max_height = 25;
        default_detail = 1;
      };
    };
  };

  extraConfigLua = lib.mkIf config.plugins.overseer.enable ''
    -- Custom Go test tasks for overseer
    local overseer = require("overseer")

    -- Go test in current directory
    overseer.register_template({
      name = "go test (current dir)",
      builder = function()
        return {
          cmd = { "go" },
          args = { "test", "-v", "./..." },
          cwd = vim.fn.getcwd(),
        }
      end,
      condition = {
        filetype = { "go" },
      },
    })

    -- Go test with -run filter (prompts for pattern)
    overseer.register_template({
      name = "go test -run (filtered)",
      params = {
        pattern = {
          type = "string",
          desc = "Test name pattern for -run flag",
          default = "",
        },
      },
      builder = function(params)
        local args = { "test", "-v" }
        if params.pattern and params.pattern ~= "" then
          table.insert(args, "-run")
          table.insert(args, params.pattern)
        end
        table.insert(args, "./...")
        return {
          cmd = { "go" },
          args = args,
          cwd = vim.fn.getcwd(),
        }
      end,
      condition = {
        filetype = { "go" },
      },
    })

    -- Go test current file's package
    overseer.register_template({
      name = "go test (current package)",
      builder = function()
        local file_dir = vim.fn.expand("%:p:h")
        return {
          cmd = { "go" },
          args = { "test", "-v", "." },
          cwd = file_dir,
        }
      end,
      condition = {
        filetype = { "go" },
      },
    })
  '';

  keymaps = lib.optionals config.plugins.overseer.enable [
    # General compile/run (like Doom SPC c c)
    {
      mode = "n";
      key = "<leader>cc";
      action = "<cmd>OverseerRun<cr>";
      options.desc = "Compile/Run task";
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = "<cmd>OverseerToggle<cr>";
      options.desc = "Toggle task list";
    }
    {
      mode = "n";
      key = "<leader>cR";
      action = "<cmd>OverseerQuickAction restart<cr>";
      options.desc = "Restart last task";
    }
    {
      mode = "n";
      key = "<leader>cq";
      action = "<cmd>OverseerQuickAction<cr>";
      options.desc = "Quick action on task";
    }

    # Go-specific test keymaps
    {
      mode = "n";
      key = "<leader>cg";
      action.__raw = ''
        function()
          require("overseer").run_template({ name = "go test (current dir)" })
        end
      '';
      options.desc = "Go test (all)";
    }
    {
      mode = "n";
      key = "<leader>cG";
      action.__raw = ''
        function()
          require("overseer").run_template({ name = "go test -run (filtered)" })
        end
      '';
      options.desc = "Go test (filtered)";
    }
    {
      mode = "n";
      key = "<leader>cp";
      action.__raw = ''
        function()
          require("overseer").run_template({ name = "go test (current package)" })
        end
      '';
      options.desc = "Go test (package)";
    }
  ];
}
