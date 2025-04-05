{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins = {
    snacks = {
      settings = {
        scratch = {
          enabled = true;
          autosave = true;
        };
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "scratch" config.plugins.snacks.settings
        && config.plugins.snacks.settings.scratch.enabled
      )
      [
        {
          mode = "n";
          key = "<leader>ss";
          action = ''<cmd>lua Snacks.scratch({ft = 'go'})<cr>'';
          options = {
            desc = "Open Scratch Buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>sr";
          action = ''<cmd>w | term go run %<cr>'';
          options = {
            desc = "Open Scratch Buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>so";
          action = ''<cmd>lua Snacks.scratch.open()<cr>'';
          options = {
            desc = "Open Scratch Buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>sb";
          action = ''<cmd>lua Snacks.scratch.select()<cr>'';
          options = {
            desc = "Select Scratch Buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>sl";
          action = ''<cmd>lua Snacks.scratch.list()<cr>'';
          options = {
            desc = "List Scratch Buffers";
          };
        }
      ];
}
