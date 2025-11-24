{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    # flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";

      # Only need unstable until the lpeg fix hits mainline, probably
      # not very long... can safely switch back for 23.11.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blink-cmp = {
      url = "github:saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixvim,
      flake-utils,
      nixpkgs,
      self,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [
          # inputs.neovim-nightly-overlay.overlays.default
          # Fix lualine luarocks hash mismatch by using git source directly
          (final: prev: {
            vimPlugins = prev.vimPlugins // {
              lualine-nvim = prev.vimUtils.buildVimPlugin {
                pname = "lualine.nvim";
                version = "2024-08-12";
                src = prev.fetchFromGitHub {
                  owner = "nvim-lualine";
                  repo = "lualine.nvim";
                  rev = "0a5a66803c7407767b799067986b4dc3036e1983";
                  sha256 = "sha256-WcH2dWdRDgMkwBQhcgT+Z/ArMdm+VbRhmQftx4t2kNI=";
                };
                meta.homepage = "https://github.com/nvim-lualine/lualine.nvim/";
              };
            };
          })
        ];
        nixvimLib = nixvim.lib.${system};
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit pkgs; # or alternatively, set `pkgs`
          module = import ./config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
            inherit inputs self;
          } // import ./lib { inherit pkgs; };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;

      in
      {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };
      }
    );
}
