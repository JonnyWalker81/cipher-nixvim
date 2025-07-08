# Haskell File Crash - Root Cause Analysis

## The Problem
Opening ANY Haskell file (`.hs`, `.lhs`, `.hsc`) causes Neovim to crash with a malloc error. This happens immediately upon opening the file, before any user interaction.

## Root Cause
The crash is most likely caused by:

1. **Corrupted Haskell Treesitter Parser** - The Haskell parser binary might be corrupted in the Nix store
2. **Incompatible Parser Version** - The Haskell parser might be incompatible with your Neovim version
3. **Memory Bug in Parser** - The parser might have a memory allocation bug with certain file patterns

## Immediate Fix

### Option 1: Disable All Haskell Support (Recommended)
Add to your `config/default.nix`:
```nix
imports = [
  ./disable-all-haskell.nix  # Must be first to override other configs
  # ... other imports
];
```

This will:
- Prevent Haskell treesitter parser from loading
- Force Haskell files to open as plain text
- Disable all Haskell-specific features
- Show a warning when opening Haskell files

### Option 2: Quick Command-Line Workaround
```bash
# Open Haskell files with minimal Neovim
nvim -u NONE file.hs

# Or with syntax but no treesitter
nvim --cmd "let g:loaded_nvim_treesitter = 1" file.hs
```

## Testing the Issue

Run the diagnostic script:
```bash
./test-haskell-crash.sh
```

This will help determine:
- If the crash happens even without any config
- If it's specific to your nixvim setup
- If treesitter is the culprit

## Long-term Solutions

### 1. Rebuild Treesitter Parsers
```bash
# Clear treesitter cache
rm -rf ~/.local/share/nvim/tree-sitter

# Rebuild nixvim
nix flake update
nix build . --rebuild
```

### 2. Use Different Parser Source
In your flake.nix, you might try:
```nix
# Use a different treesitter revision
inputs.nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter?rev=<older-commit>";
```

### 3. Report the Bug
This appears to be a bug in either:
- The Haskell treesitter parser
- Neovim's treesitter integration
- The Nix packaging of the parser

Report to: https://github.com/tree-sitter/tree-sitter-haskell/issues

## Safe Haskell Editing

After applying the fix, you can:
1. Use `:SafeHaskell file.hs` to open files safely
2. Edit Haskell files as plain text (no syntax highlighting)
3. Use an external editor for Haskell work temporarily

## Why This Happens

The malloc error suggests memory corruption during parser initialization. This could be due to:
- The parser trying to allocate too much memory
- A null pointer dereference
- Buffer overflow in the parser code
- Incompatibility between parser and Neovim's allocator

The fact that it only affects Haskell files points to a specific issue with the Haskell parser implementation.