# Formatting Configuration

All common programming languages now have automatic format-on-save configured.

## Configured Languages and Formatters

### Systems Programming
- **C/C++** → `clang-format` (Google style, 4 space indent, 100 char limit)
- **Rust** → `rustfmt`
- **Go** → `goimports`
- **Zig** → `zigfmt`

### Web Development
- **HTML** → `prettier` (with prettierd fallback)
- **CSS/SCSS/Less** → `prettier` (with prettierd fallback)
- **JavaScript/TypeScript** → `eslint_d` + `prettier`
- **JSON** → `prettier`
- **XML** → `xmlformat`

### Scripting Languages
- **Python** → `ruff` (with black fallback)
- **Shell (sh/bash)** → `shfmt`
- **Lua** → `stylua`

### Infrastructure as Code
- **Terraform** → `terraform_fmt`
- **HCL** → `hclfmt`
- **YAML** → `yamlfmt`
- **Nix** → `nixfmt`
- **Docker** → `dockerfile-language-server`

### Config Files
- **TOML** → `taplo`
- **Makefile** → `trim_whitespace`
- **CMake** → `cmake_format`

### Other Languages
- **OCaml** → `ocamlformat`
- **SQL** → `sql_formatter` (PostgreSQL dialect)
- **Markdown** → `prettier`

## Format on Save

Format on save is **enabled by default** with:
- Automatic formatting when you save (`:w`)
- LSP fallback if no formatter is configured
- Different timeouts for different file types:
  - HTML/XML: 2 seconds
  - JS/TS/React: 1.5 seconds
  - Others: 1 second

## Manual Formatting

You can also manually format with:
- `<leader>cf` - Format current file or selection

## Notifications

- Formatting errors will be shown as notifications
- Info level logging is enabled for debugging

## Disabling Format on Save

If you want to disable format on save for specific file types, add them to the `disable_filetypes` list in the configuration.

## Notes

1. Some formatters require the language toolchain to be installed (e.g., rubocop needs Ruby)
2. The configuration uses `prettierd` for faster formatting where possible
3. Multiple formatters are configured with fallbacks (e.g., `ruff` → `black` for Python)
4. All formatters preserve your code's functionality while improving consistency