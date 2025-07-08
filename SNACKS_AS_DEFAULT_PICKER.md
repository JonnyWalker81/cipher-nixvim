# Snacks as Default File Picker

Snacks picker is now configured as the default file picker instead of Telescope.

## Key Bindings

These keybindings now use Snacks picker:
- `<leader><leader>` - Find files
- `<leader><space>` - Find files (alternative)
- `<leader>/` - Live grep
- `<leader>bb` - Find buffers
- `<leader>fr` - Recent files
- `<leader>ff` - Find files
- `<leader>fg` - Live grep

## Features

### Toggle Between Pickers
You can switch between Snacks and Telescope at runtime:
```vim
:TogglePicker
```

### Smart Functions
The configuration provides smart functions that respect your picker choice:
```lua
_G.smart_find_files()  -- Uses current picker
_G.smart_grep()        -- Uses current picker
```

## Why Snacks?

According to the comments in your config, "fzf-lua feels better in every way", and Snacks picker provides:
- Better performance
- More modern UI
- Frecency-based sorting (frequently + recently used)
- Better integration with other Snacks features

## Telescope Still Available

Telescope remains available for features that Snacks doesn't provide:
- `:Telescope colorscheme` - Theme picker
- `:Telescope help_tags` - Help browser
- `:Telescope commands` - Command palette

## Customization

The Snacks picker is configured in `config/plugins/snacks/picker.nix` with:
- Custom layout (horizontal split with preview)
- Frecency matching enabled
- Debug options for troubleshooting

## Note on Haskell Files

With the Haskell treesitter disabled, you can now safely use Snacks picker to browse and select Haskell files without crashes.