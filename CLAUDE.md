# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a nixvim configuration repository that provides a declarative Neovim configuration using Nix. The configuration is structured as a Nix flake that produces a fully configured Neovim package.

## Essential Commands

### Testing Configuration
```bash
# Run the configured Neovim to test changes
nix run .

# Verify configuration is valid (catches syntax errors and invalid options)
nix flake check

# Build the Neovim derivation without running it
nix build .
```

### Development Workflow
```bash
# After making changes, always run:
nix flake check  # Validates the configuration
nix run .        # Tests the actual Neovim instance

# If you get "path does not exist" errors during flake check:
git add <new-file>  # Flake checks require files to be staged in git
```

## Architecture & Key Concepts

### Configuration Structure
The configuration follows a modular architecture where each aspect of Neovim is configured in separate Nix files:

- **Entry Point**: `flake.nix` defines the Nix flake that builds the Neovim package
- **Main Config**: `config/default.nix` imports all configuration modules
- **Plugin Organization**: `config/plugins/default.nix` imports categorized plugin configurations:
  - `ai/` - AI assistants (Copilot, Supermaven, Avante)
  - `completion/` - Completion engines (Blink)
  - `editor/` - Editor enhancements (Flash, Yanky, etc.)
  - `git/` - Git integration
  - `lang/` - Language-specific LSP configurations
  - `lsp/` - Core LSP and formatting setup
  - `theme/` - Colorscheme configurations
  - `ui/` - UI enhancements (Lualine, Alpha, etc.)

### Key Implementation Patterns

#### 1. Lazy Loading with lz-n
Many plugins support lazy loading via the `lazyLoad` attribute:
```nix
plugins.telescope = {
  enable = true;
  lazyLoad = {
    enable = true;
    settings = {
      cmd = [ "Telescope" ];
      keys = [ { __unkeyed-1 = "<leader>ff"; desc = "Find files"; } ];
    };
  };
};
```

#### 2. Conditional Configuration
Use `lib.mkIf` and `lib.optionals` for conditional settings:
```nix
keymaps = lib.optionals config.plugins.avante.enable [ ... ];
```

#### 3. Raw Lua Code
For complex logic, use `__raw` or direct Lua strings:
```nix
settings.cond.__raw = ''
  function()
    return vim.fn.argc() == 0
  end
'';
```

#### 4. Icon System
Icons are centralized in `lib/icons.nix` and referenced throughout:
```nix
{ icons, ... }: {
  plugins.lualine.settings.sections.lualine_c = [
    { __unkeyed = icons.diagnostics.Error; }
  ];
}
```

### Common Pitfalls & Solutions

#### LazyLoad Support
Not all plugins support the `lazyLoad` attribute. Check nixvim documentation or use flake check to verify. Plugins without support will error with "The option `plugins.<name>.lazyLoad' does not exist".

#### String Interpolation in Lua
When using `extraConfigLua`, be careful with single quotes in Lua strings within Nix multiline strings:
```nix
# Bad - will cause syntax error
cond.__raw = ''
  vim.fn.finddir('.git', path)
'';

# Good - use double quotes
cond.__raw = ''
  vim.fn.finddir(".git", path)
'';
```

#### LSP Capabilities
The `plugins.lsp.capabilities` option expects a string, not an attribute set:
```nix
# Wrong
capabilities.__raw = ''...''

# Correct  
capabilities = ''...''
```

#### Multiple extraConfigLua
You cannot define `extraConfigLua` multiple times in the same scope. Merge all Lua code into a single `extraConfigLua` block.

### Performance Considerations

1. **Lazy Loading**: Always enable lazy loading for heavy plugins (Telescope, Treesitter extensions, Git plugins)
2. **Treesitter**: Disable `additional_vim_regex_highlighting` for better performance
3. **LSP**: Language servers auto-start based on filetype - no need for manual optimization

### Testing Plugin Changes

When adding/modifying plugins:
1. Check if the plugin supports nixvim's `lazyLoad` mechanism
2. Verify keybindings don't conflict using the keymaps defined across files
3. Run `nix flake check` to catch configuration errors
4. Test the actual functionality with `nix run .`

### Flake Inputs

The flake uses several key inputs:
- `nixvim` - The main nixvim framework
- `nixpkgs` - Unstable channel for latest packages
- `neovim-nightly-overlay` - For bleeding-edge Neovim features
- `blink-cmp` - Modern completion engine