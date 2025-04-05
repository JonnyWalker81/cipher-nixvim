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
        animate.enabled = true;
        image.enabled = true;
        indent.enabled = true;
        scroll.enabled = true;
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
