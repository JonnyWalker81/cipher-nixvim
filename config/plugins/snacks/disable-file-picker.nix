# Disable snacks picker for file searches to avoid malloc crash
# Use telescope instead for file operations
{ config, lib, ... }:
{
  # Remove the file search keybinding from snacks
  # This is done by filtering out the problematic keymaps
  keymaps = lib.mkAfter (
    builtins.filter (keymap: 
      # Remove the <leader><leader> mapping that uses snacks file picker
      keymap.key != "<leader><leader>"
    ) config.keymaps or []
  );

  # Add telescope as the replacement for file search
  plugins.telescope.keymaps = lib.mkIf config.plugins.telescope.enable {
    # Override the <leader><leader> to use telescope instead
    "<leader><leader>" = {
      action = "find_files hidden=true";
      options.desc = "Find files (using telescope)";
    };
  };
}