# Comprehensive formatter configuration combining existing and new formatters
{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    settings = {
      formatters_by_ft = lib.mkMerge [
        # Keep existing formatters from language files
        {
          # From go.nix
          go = [ "goimports" ];
          
          # From hcl.nix
          hcl = [ "hclfmt" ];
          
          # From json.nix
          json = [ "prettier" ];
          
          # From nix.nix
          nix = [ "nixfmt" ];
          
          # From ocaml.nix
          ocaml = [ "ocamlformat" ];
          
          # From rust.nix
          rust = [ "rustfmt" ];
          
          # From shell.nix
          sh = [ "shfmt" ];
          
          # From terraform.nix
          tf = [ "terraform_fmt" ];
          terraform = [ "terraform_fmt" ];
          
          # From typescript.nix (enhanced)
          javascript = [[ "eslint_d" "prettierd" "prettier" ]];
          javascriptreact = [[ "eslint_d" "prettierd" "prettier" ]];
          typescript = [[ "eslint_d" "prettierd" "prettier" ]];
          typescriptreact = [[ "eslint_d" "prettierd" "prettier" ]];
          svelte = [ "eslint_d" ];
          
          # From yaml.nix
          yaml = [ "yamlfmt" ];
          yml = [ "yamlfmt" ];
          
          # From zig.nix
          zig = [ "zigfmt" ];
        }
        
        # Add missing formatters
        {
          # C/C++
          c = [ "clang-format" ];
          cpp = [ "clang-format" ];
          h = [ "clang-format" ];
          hpp = [ "clang-format" ];
          
          # Web development
          html = [[ "prettierd" "prettier" ]];
          xml = [ "xmlformat" ];
          css = [[ "prettierd" "prettier" ]];
          scss = [[ "prettierd" "prettier" ]];
          less = [[ "prettierd" "prettier" ]];
          
          # Python
          python = [[ "ruff_format" "black" ]];
          
          # Lua
          lua = [ "stylua" ];
          
          # Markdown
          markdown = [[ "prettierd" "prettier" ]];
          
          # Config files
          toml = [ "taplo" ];
          jsonc = [[ "prettierd" "prettier" ]];
          
          # SQL
          sql = [ "sql_formatter" ];
          
          # Docker
          dockerfile = [ "dockerfile-language-server" ];
          
          # Make
          make = [ "trim_whitespace" ];
          cmake = [ "cmake_format" ];
        }
      ];
      
      # Additional formatter configurations
      formatters = {
        clang-format = {
          command = "${pkgs.clang-tools}/bin/clang-format";
          args = [ 
            "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 100}" 
          ];
        };
        
        ruff_format = {
          command = "${pkgs.ruff}/bin/ruff";
          args = [ "format" "--stdin-filename" "$FILENAME" "-" ];
          stdin = true;
        };
        
        black = {
          command = "${pkgs.black}/bin/black";
          args = [ "--quiet" "--stdin-filename" "$FILENAME" "-" ];
          stdin = true;
        };
        
        stylua = {
          command = "${pkgs.stylua}/bin/stylua";
          args = [ "--search-parent-directories" "--stdin-filepath" "$FILENAME" "-" ];
          stdin = true;
        };
        
        xmlformat = {
          command = "${pkgs.xmlformat}/bin/xmlformat";
          args = [ "-" ];
          stdin = true;
        };
        
        sql_formatter = {
          command = "${pkgs.nodePackages.sql-formatter}/bin/sql-formatter";
          args = [ "--language" "postgresql" ];
          stdin = true;
        };
        
        taplo = {
          command = "${pkgs.taplo}/bin/taplo";
          args = [ "format" "-" ];
          stdin = true;
        };
        
        cmake_format = {
          command = "${pkgs.cmake-format}/bin/cmake-format";
          args = [ "-" ];
          stdin = true;
        };
        
        prettier = {
          command = "${pkgs.nodePackages.prettier}/bin/prettier";
          args = [ "--stdin-filepath" "$FILENAME" ];
          stdin = true;
        };
        
        prettierd = {
          command = "${pkgs.prettierd}/bin/prettierd";
          args = [ "$FILENAME" ];
          stdin = true;
        };
      };
    };
  };
  
  # Ensure format on save is properly configured
  plugins.conform-nvim.settings = {
    format_on_save = lib.mkForce ''
      function(bufnr)
        -- Disable format on save for certain file types
        local disable_filetypes = { 
          -- Add any filetypes you want to exclude
        }
        
        local filetype = vim.bo[bufnr].filetype
        if vim.tbl_contains(disable_filetypes, filetype) then
          return nil
        end
        
        -- Different timeouts for different file types
        local timeout_map = {
          html = 2000,
          xml = 2000,
          typescript = 1500,
          typescriptreact = 1500,
          javascript = 1500,
          javascriptreact = 1500,
        }
        
        return {
          timeout_ms = timeout_map[filetype] or 1000,
          lsp_fallback = true,
        }
      end
    '';
    
    # Log formatting actions for debugging
    log_level = "info";
    notify_on_error = true;
  };
  
  # Add packages needed for formatters
  extraPackages = with pkgs; [
    # C/C++
    clang-tools
    
    # Python
    ruff
    black
    
    # Web
    nodePackages.prettier
    prettierd
    
    # Others
    stylua
    xmlformat
    taplo
    cmake-format
    nodePackages.sql-formatter
  ];
}