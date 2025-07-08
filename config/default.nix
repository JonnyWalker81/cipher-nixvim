{
  # Import all your configuration modules here
  imports = [
    ./disable-all-haskell.nix  # Disable Haskell support to prevent crashes
    ./lazy.nix
    ./settings.nix
    ./bufferline.nix
    ./keymaps.nix
    ./plugins
  ];
}
