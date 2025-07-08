# Terraform Formatting Guide

## Current Configuration

Terraform files should now format automatically on save. The configuration includes:

1. **File types covered**:
   - `.tf` files → recognized as `terraform` filetype
   - `.tfvars` files → recognized as `terraform` filetype

2. **Formatter**: `terraform fmt` command
   - Uses stdin/stdout for formatting
   - Integrated with conform.nvim

3. **Automatic triggers**:
   - Format on save (BufWritePre autocmd)
   - 1 second timeout

## Troubleshooting

### Check if formatting is working:

1. **Open a .tf file** and you should see notifications:
   - "Terraform formatters: terraform_fmt"
   - "Format on save enabled: true"

2. **Test manual formatting**:
   ```vim
   :FormatTerraform
   ```

3. **Check formatter availability**:
   ```vim
   :ConformInfo
   ```
   Look for `terraform_fmt` in the list.

### If formatting is NOT working:

1. **Check if terraform is installed**:
   ```bash
   which terraform
   terraform version
   ```

2. **Check the file type**:
   ```vim
   :set filetype?
   ```
   Should show `filetype=terraform`

3. **Enable debug notifications**:
   The current config will show notifications when:
   - A terraform file is opened
   - Formatting is attempted
   - Errors occur

4. **Manual format command**:
   ```vim
   :lua require("conform").format({ async = false })
   ```

### Common Issues:

1. **Wrong filetype**: If `:set filetype?` shows `tf` instead of `terraform`, the filetype detection isn't working.

2. **Terraform not in PATH**: Make sure terraform is available in your environment.

3. **Invalid HCL syntax**: Terraform fmt won't format files with syntax errors. Check:
   ```bash
   terraform validate
   ```

## Manual Override

If automatic formatting still doesn't work, you can:

1. Format manually with `:FormatTerraform`
2. Use command line: `terraform fmt`
3. Set up a keymap: `<leader>cf` already mapped to format