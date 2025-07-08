{
  # Import all your configuration modules here
  imports = [
    ./fix-haskell-preview-crash-final.nix  # Final fix - disable preview for Haskell files
    ./lazy.nix
    ./settings.nix
    ./bufferline.nix
    ./keymaps.nix
    ./plugins
  ];
}
