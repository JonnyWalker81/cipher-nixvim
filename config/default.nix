{
  # Import all your configuration modules here
  imports = [
    ./disable-haskell-simple.nix  # Simple fix to prevent Haskell crashes
    ./use-snacks-picker.nix  # Use snacks as default file picker
    ./debug-terraform-format.nix  # Fix terraform formatting
    ./lazy.nix
    ./settings.nix
    ./bufferline.nix
    ./keymaps.nix
    ./plugins
  ];
}
