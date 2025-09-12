{ pkgs, ... }:
{
  plugins = {
    bacon.enable = true;
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft.rust = [ "rustfmt" ];
      };
    };
    # Temporarily disable rustaceanvim to avoid neotest dependency
    rustaceanvim.enable = false;
    
    # Use basic rust-tools as a temporary replacement
    lsp.servers.rust_analyzer = {
      enable = true;
      installRustc = true;
      installCargo = true;
      settings = {
        cargo.allFeatures = true;
        check.command = "clippy";
        files.excludeDirs = [
          "target"
          ".git"
          ".cargo"
          ".github"
          ".direnv"
        ];
        inlayHints.lifetimeElisionHints.enable = "always";
      };
    };
  };
}