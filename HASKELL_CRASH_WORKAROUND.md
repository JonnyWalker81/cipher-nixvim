# Haskell Preview Crash - Final Workaround

## The Problem
The malloc crash occurs when telescope/snacks try to preview Haskell files, even with treesitter disabled. This appears to be a deeper issue with how Neovim handles certain file types in preview buffers.

## The Solution
Since disabling treesitter didn't help, we now completely skip preview for Haskell files while keeping it for all other file types.

## What You'll See

### When browsing Haskell files:
Instead of a preview, you'll see:
```
  Haskell File Preview Disabled
  
  File: xmonad.hs
  Size: 23504 bytes
  
  (Preview disabled to prevent crashes)
  
  Press <Enter> to open the file
```

### For all other files:
Normal preview works as expected.

## Quick Commands

### Search without any preview:
```vim
:TelescopeNoPreview find_files
:TelescopeNoPreview live_grep
```

### Toggle preview on/off:
Press `<leader>fp` to toggle preview in telescope

### In Haskell projects:
You'll see a notification suggesting to use `:TelescopeNoPreview find_files`

## Alternative: Use FZF
If you need to work extensively with Haskell files:
```bash
# In terminal
fzf --preview 'bat --color=always {}'

# Or without preview
fzf
```

## Why This Happens
The crash appears to be related to:
1. Memory allocation when loading large Haskell files into preview buffers
2. Possible interaction with Nix's memory management
3. Some specific pattern in Haskell files that triggers the bug

## Long-term Fix
This needs to be reported and fixed at the Neovim core level. The workaround prevents the crash while maintaining functionality.