# Additional formatter configuration for languages not already configured
{ pkgs, lib, ... }:
{
  plugins.conform-nvim.settings = {
    # Only add formatters for languages that don't already have them
    formatters_by_ft = lib.mkDefault {
      # C/C++
      c = [ "clang-format" ];
      cpp = [ "clang-format" ];
      h = [ "clang-format" ];
      hpp = [ "clang-format" ];
      
      # Web development (not conflicting with typescript.nix)
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
    };
    
    # Enhance JavaScript/TypeScript formatters (add prettier as fallback)
    formatters_by_ft = lib.mkAfter {
      javascript = lib.mkForce [[ "eslint_d" "prettierd" "prettier" ]];
      javascriptreact = lib.mkForce [[ "eslint_d" "prettierd" "prettier" ]];
      typescript = lib.mkForce [[ "eslint_d" "prettierd" "prettier" ]];
      typescriptreact = lib.mkForce [[ "eslint_d" "prettierd" "prettier" ]];
    };
    
    # Additional formatter configurations
    formatters = lib.mkMerge [
      {
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
      }
    ];
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