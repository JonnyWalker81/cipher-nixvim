{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.avante.enable [
    pkgs.vimPlugins.img-clip-nvim
  ];

  plugins = {
    avante = {
      enable = true;
      package = pkgs.vimPlugins.avante-nvim.overrideAttrs {
        # patches = [
        #   # Patch blink support
        #   (pkgs.fetchpatch {
        #     url = "https://github.com/doodleEsc/avante.nvim/commit/a5438d0f16208b7ae9e97ae354bed5ec16b4f9ed.patch";
        #     hash = "sha256-KyfO9dE27yMXOQhpit7jmzkvnfM7b5kr2Acoh011lXA=";
        #   })
        # ];
      };
      
      lazyLoad = {
        enable = lib.mkDefault true;
        settings = {
          cmd = [ "AvanteAsk" "AvanteBuild" "AvanteEdit" "AvanteRefresh" "AvanteSwitchProvider" "AvanteChat" "AvanteToggle" "AvanteClear" "AvanteShowRepoMap" ];
        };
      };

      settings = {
        provider = "copilot";
        # openai = {
        #   # api_key = builtins.getEnv "OPENAI_API_KEY";
        #   model = "gpt-4";
        #   temperature = 0.7;
        #   max_tokens = 1024;
        # };
        behavior = {
          auto_set_keymaps = true;
          auto_approve_tool_permissions = true;
        };

        mappings = {
          files = {
            add_current = "<leader>a.";
          };

          diff = {
            theirs = "ct"; # accept AI change
            ours = "co"; # keep mine
            next = "gn";
            prev = "gN";
          };
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>a";
        group = "Avante";
        icon = "";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.avante.enable [
    {
      mode = "n";
      key = "<leader>aa";
      action = "<CMD>AvanteAsk<CR>";
      options.desc = "avante: ask";
    }
    {
      mode = "v";
      key = "<leader>aa";
      action = "<CMD>AvanteAsk<CR>";
      options.desc = "avante: ask";
    }
    {
      mode = "n";
      key = "<leader>ae";
      action = "<CMD>AvanteEdit<CR>";
      options.desc = "avante: edit";
    }
    {
      mode = "v";
      key = "<leader>ae";
      action = "<CMD>AvanteEdit<CR>";
      options.desc = "avante: edit selection";
    }
    {
      mode = "n";
      key = "<leader>ar";
      action = "<CMD>AvanteRefresh<CR>";
      options.desc = "avante: refresh";
    }
    {
      mode = "n";
      key = "<leader>at";
      action = "<CMD>AvanteToggle<CR>";
      options.desc = "avante: toggle";
    }
    {
      mode = "n";
      key = "<leader>ac";
      action = "<CMD>AvanteClear<CR>";
      options.desc = "avante: clear";
    }
    {
      mode = "n";
      key = "<leader>ab";
      action = "<CMD>AvanteBuild<CR>";
      options.desc = "avante: build project";
    }
    {
      mode = "n";
      key = "<leader>as";
      action = "<CMD>AvanteSwitchProvider<CR>";
      options.desc = "avante: switch provider";
    }
    {
      mode = "n";
      key = "<leader>aS";
      action = "<CMD>AvanteShowRepoMap<CR>";
      options.desc = "avante: show repo map";
    }
    {
      mode = "n";
      key = "<leader>aC";
      action = "<CMD>AvanteChat<CR>";
      options.desc = "avante: chat";
    }
  ];
}
