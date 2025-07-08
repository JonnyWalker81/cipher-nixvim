# Haskell Preview Crash Fix

## Problem
Both telescope and snacks crash with a malloc error when searching for files that start with "xmon" in Haskell projects. The crash occurs when the preview window tries to render Haskell files.

## Root Cause
The crash is triggered by the preview feature when it attempts to:
1. Load and parse Haskell files (especially large ones like xmonad.hs)
2. Apply treesitter syntax highlighting in the preview window
3. Handle the specific pattern "xmon" which matches xmonad.hs

## Solution Applied

### Primary Fix: Disable Preview for Haskell Files
The `fix-haskell-preview-crash.nix` module:
1. Disables preview for `.hs` files in telescope
2. Disables treesitter in preview windows for Haskell
3. Automatically disables preview when in Haskell projects

### How It Works
- When telescope encounters a `.hs` file, it shows a message instead of previewing
- Treesitter is disabled in preview windows to prevent parsing crashes
- In Haskell projects (detected by stack.yaml, cabal.project, or *.cabal files), preview is disabled entirely

## Usage

### Temporary Workaround (Immediate)
If you need to search in a Haskell project right now:
```vim
:Telescope find_files previewer=false
```

### After Applying the Fix
```bash
nix flake check
nix run .
```

The fix will automatically:
- Disable preview for Haskell files
- Show "Haskell preview disabled to prevent crashes" message
- Still allow you to search and select files normally

## Alternative Solutions

### 1. Disable Preview Globally
If you prefer no previews at all:
```nix
plugins.telescope.settings.defaults.preview = false;
```

### 2. Use FZF in Terminal
For Haskell projects, you might prefer:
```bash
cd ~/nixos-config && fzf
```

### 3. Disable Treesitter for Haskell
If the issue persists:
```nix
plugins.treesitter.settings.ensure_installed = 
  builtins.filter (x: x != "haskell") config.plugins.treesitter.settings.ensure_installed;
```

## Reporting the Bug
This appears to be a bug in either:
- The Haskell treesitter parser
- Neovim's preview buffer handling
- Memory management when rendering large Haskell files

Consider reporting to:
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/issues) if it's parser-related
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim/issues) with the malloc error details
- [Neovim](https://github.com/neovim/neovim/issues) if it's a core memory issue