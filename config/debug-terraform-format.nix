# Debug and fix Terraform formatting issues
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

  # Add debugging and ensure proper filetype detection
  extraConfigLua = ''
    -- Ensure .tf files are recognized as terraform filetype
    vim.filetype.add({
      extension = {
        tf = "terraform",
        tfvars = "terraform",
      },
    })
    
    -- Create command to manually test terraform formatting
    vim.api.nvim_create_user_command("FormatTerraform", function()
      require("conform").format({ async = false, lsp_fallback = true })
    end, { desc = "Manually format terraform file" })
    
    -- Debug conform setup for terraform files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "terraform", "tf" },
      callback = function()
        vim.schedule(function()
          local conform = require("conform")
          local formatters = conform.list_formatters(0)
          local names = vim.tbl_map(function(f) return f.name end, formatters)
          
          if #names == 0 then
            vim.notify("No formatters available for terraform!", vim.log.levels.WARN)
          else
            vim.notify("Terraform formatters: " .. table.concat(names, ", "), vim.log.levels.INFO)
          end
          
          -- Check if format on save is enabled
          local will_format = conform.will_format_on_save()
          vim.notify("Format on save enabled: " .. tostring(will_format), vim.log.levels.INFO)
        end)
      end
    })
    
    -- Force format on save for terraform files
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.tf", "*.tfvars" },
      callback = function(args)
        -- Force conform to format
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