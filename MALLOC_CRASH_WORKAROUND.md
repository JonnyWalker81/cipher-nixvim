# Snacks Picker Malloc Crash Workaround

## Current Status
The malloc crash when typing "x" in snacks picker file search is still occurring despite the module loading fix. As a workaround, I've disabled the snacks file picker and mapped file search to use telescope instead.

## Changes Made

1. **Disabled snacks picker for `<leader><leader>`** in `config/plugins/snacks/picker.nix`
   - The problematic keymap is now commented out
   
2. **Added telescope mapping for `<leader><leader>`** in `config/plugins/telescope/default.nix`
   - This provides the same functionality using telescope which doesn't have the crash

## Usage
- Use `<leader><leader>` or `<leader><space>` for file search (both now use telescope)
- All other snacks features remain enabled and functional

## Other Options

### Option 1: Use fzf-lua (Recommended in config comments)
```nix
# In your configuration
plugins.fzf-lua = {
  enable = true;
  keymaps = {
    "<leader><leader>" = {
      action = "files";
      options.desc = "Find files";
    };
  };
};
```

### Option 2: Disable snacks picker entirely
```nix
# Remove or comment out the picker.nix import
imports = [
  # ./picker.nix  # Commented out due to malloc crash
];
```

### Option 3: Use a different key for snacks file search
If you want to keep testing snacks picker without risking the crash on your main workflow:
```nix
{
  mode = "n";
  key = "<leader>sf";  # Different key to avoid muscle memory
  action = ''<cmd>lua Snacks.picker.files({hidden = true})<cr>'';
  options = {
    desc = "Snacks find files (may crash with 'x')";
  };
}
```

## Next Steps
- Report this issue to [snacks.nvim](https://github.com/folke/snacks.nvim/issues) with:
  - The fact it only happens in specific repositories
  - The malloc error occurs specifically when typing "x"
  - It happens with Nix-packaged Neovim
  - Include the diagnostic output showing the module loading issue