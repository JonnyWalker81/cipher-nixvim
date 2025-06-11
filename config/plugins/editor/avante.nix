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
        };

        mappings = {
          files = {
            add_current = "<leader>a.";
          };

          diff = {
            theirs = "<leader>at"; # accept AI change
            ours = "<leader>ao"; # keep mine
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
      key = "<leader>ac";
      action = "<CMD>AvanteClear<CR>";
      options.desc = "avante: clear";
    }
  ];
}
