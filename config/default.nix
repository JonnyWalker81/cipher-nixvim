{
  # Import all your configuration modules here
  imports = [
    ./fix-haskell-preview-crash-v2.nix  # Use v2 that keeps preview but disables treesitter
    ./lazy.nix
    ./settings.nix
    ./bufferline.nix
    ./keymaps.nix
    ./plugins
  ];
}
