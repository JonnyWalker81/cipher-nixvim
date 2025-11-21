{
  config,
  self,
  # system,
  pkgs,
  ...
}:
{
  imports = [
    ./bigfile.nix
    ./bufdelete.nix
    # FIXME: inf recursion trying to logic gate
    # ./dashboard.nix
    # ./gitbrowse.nix
    ./lazygit.nix
    ./picker.nix
    ./scratch.nix
    # ./profiler.nix
    ./zen.nix
    ./fix-module-loading.nix
  ];

  extraPackages = with pkgs; [
    # PDF rendering
    # ghostscript
    # Mermaid diagrams
    # mermaid-cli
    # LaTeX
    # tectonic
  ];

  plugins = {
    snacks = {
      enable = true;
      # package = self.packages.${system}.snacks-nvim;

      settings = {
        # Performance: disabled cursor-tracking features
        animate.enabled = false;  # Cursor/scroll animation
        image.enabled = true;
        indent.enabled = false;   # Indent guides update on cursor move
        scroll.enabled = false;   # Smooth scroll fires on every j/k
        scope.enabled = false;    # Scope tracking on cursor position
        statuscolumn = {
          enabled = true;

          folds = {
            open = true;
            git_hl = config.plugins.gitsigns.enable;
          };
        };
      };
    };
  };
}
