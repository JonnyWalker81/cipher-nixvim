# Snacks.nvim Malloc Crash Fix

## Problem
The malloc crash when searching for files starting with "x" is caused by a module loading issue in snacks.nvim. The error occurs when snacks tries to access its `version` module, which doesn't exist in the Nix store paths.

## Root Cause
The issue appears to be a conflict between:
1. How snacks.nvim lazily loads its modules
2. How Nix packages Lua modules
3. The specific pattern "x" triggering a code path that tries to access `snacks.version`

## Solution

### Option 1: Apply the Module Loading Fix
Add this import to your `config/plugins/snacks/default.nix`:

```nix
imports = [
  # ... other imports
  ./fix-module-loading.nix
];
```

This fix:
- Pre-loads critical snacks modules to avoid runtime loading issues
- Patches the version module lookup to prevent crashes
- Adds error handling to the module loader

### Option 2: Disable Snacks Picker (Temporary)
If the fix doesn't work, disable snacks picker and use telescope:

```nix
# In your keymaps configuration
keymaps = lib.mkIf config.plugins.telescope.enable [
  {
    mode = "n";
    key = "<leader><leader>";
    action = "<cmd>Telescope find_files hidden=true<cr>";
    options.desc = "Find files (using telescope)";
  }
];
```

### Option 3: Use FZF-Lua Instead
The picker.nix file has a comment "Currently, fzf-lua feels better in every way", so you might want to switch:

```nix
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

## Testing
After applying the fix:
1. Run `nix flake check`
2. Run `nix run .`
3. Navigate to your NixOS config directory
4. Try searching for files with `<leader><leader>` and type "x"

## Monitoring
Check these files for any errors:
- `/tmp/snacks-picker-error.log`
- `/tmp/nvim-crash-output.txt`
- `~/.local/state/nvim/log`