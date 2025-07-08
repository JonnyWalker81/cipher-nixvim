# Clean Terraform formatting configuration without debug logging
{ config, lib, pkgs, ... }:
{
  # Override terraform formatter configuration
  plugins.conform-nvim.settings = {
    formatters_by_ft = {
      # Ensure both tf and terraform filetypes are handled
      terraform = lib.mkForce [ "terraform_fmt" ];
      tf = lib.mkForce [ "terraform_fmt" ];
    };
    
    formatters.terraform_fmt = lib.mkForce {
      command = "${pkgs.terraform}/bin/terraform";
      args = [ "fmt" "-" ];
      stdin = true;
    };
  };

  # Ensure proper filetype detection
  extraConfigLua = ''
    -- Ensure .tf files are recognized as terraform filetype
    vim.filetype.add({
      extension = {
        tf = "terraform",
        tfvars = "terraform",
      },
    })
    
    -- Force format on save for terraform files
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.tf", "*.tfvars" },
      callback = function(args)
        require("conform").format({
          bufnr = args.buf,
          async = false,
          timeout_ms = 1000,
          lsp_fallback = true,
        })
      end,
    })
  '';
}