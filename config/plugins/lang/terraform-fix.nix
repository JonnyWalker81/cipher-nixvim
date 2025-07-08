# Fix Terraform formatting to work properly
{ config, lib, pkgs, ... }:
{
  plugins.conform-nvim.settings = {
    # Add both tf and terraform filetypes
    formatters_by_ft = {
      terraform = lib.mkForce [ "terraform_fmt" ];
      tf = lib.mkForce [ "terraform_fmt" ];
      "terraform-vars" = lib.mkForce [ "terraform_fmt" ];
    };
    
    # Fix the terraform formatter command
    formatters.terraform_fmt = lib.mkForce {
      command = "${pkgs.terraform}/bin/terraform";
      args = [ "fmt" "-" ];
      stdin = true;
    };
  };

  # Ensure Terraform files are recognized
  extraConfigLua = ''
    -- Ensure .tf files are recognized as terraform filetype
    vim.filetype.add({
      extension = {
        tf = "terraform",
        tfvars = "terraform-vars",
      },
    })
    
    -- Debug formatter issues
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = {"*.tf", "*.tfvars"},
      callback = function()
        local conform = require("conform")
        local formatters = conform.list_formatters(0)
        if #formatters == 0 then
          vim.notify("No formatters found for terraform file", vim.log.levels.WARN)
        else
          vim.notify("Formatting with: " .. table.concat(vim.tbl_map(function(f) return f.name end, formatters), ", "), vim.log.levels.INFO)
        end
      end
    })
  '';
}