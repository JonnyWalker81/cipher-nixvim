# Haskell Preview with Treesitter Disabled

## Updated Solution
Instead of completely disabling preview for Haskell files, this version:
- **Keeps the preview window** so you can see file contents
- **Disables only treesitter** to prevent the malloc crash
- **Falls back to basic syntax highlighting** for readability

## How It Works

### 1. Custom Buffer Previewer
The telescope `buffer_previewer_maker` is overridden to:
- Detect Haskell files (*.hs, *.lhs, *.hsc)
- Disable all treesitter modules for those buffers
- Enable basic Vim syntax highlighting as fallback

### 2. Autocommand Safety Net
Additional autocommands ensure treesitter is disabled in:
- Preview buffers (floating windows)
- Any Haskell buffer in a floating window
- Buffers with `buftype=nofile` (typical for previews)

### 3. What You'll See
When previewing Haskell files:
- ✅ File contents are visible
- ✅ Basic syntax coloring (keywords, strings, etc.)
- ❌ No treesitter features (advanced highlighting, folding)
- ✅ No malloc crashes!

## Testing
```bash
nix flake check && nix run .
```

Then in a Haskell project:
1. Open telescope: `<leader><leader>` or `<leader><space>`
2. Type "xmon" or search for any Haskell file
3. Preview should show the file content without crashing

## Comparison

### Before (crash):
- Treesitter tries to parse large Haskell files
- Memory allocation fails
- Neovim crashes

### After (this fix):
- Treesitter is disabled for preview buffers
- Basic syntax highlighting provides readability
- No crashes, smooth experience

## Further Customization

If you want NO syntax highlighting at all in previews:
```nix
# In the fix file, comment out:
# vim.bo[bufnr].syntax = "haskell"
```

If you want to extend this to other problematic file types:
```nix
local problematic_types = {
  hs = true,
  lhs = true,
  hsc = true,
  -- Add more extensions here
}
```

## Note
This is a workaround for what appears to be a bug in the Haskell treesitter parser when used in preview contexts. The ideal fix would be at the parser level, but this provides a stable experience until that's resolved.