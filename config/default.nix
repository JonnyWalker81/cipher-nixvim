{
  # Import all your configuration modules here
  imports = [
    ./disable-haskell-simple.nix  # Simple fix to prevent Haskell crashes
    ./lazy.nix
    ./settings.nix
    ./bufferline.nix
    ./keymaps.nix
    ./plugins
  ];
}
