# Additional formatter configuration for languages not already configured
{ pkgs, lib, ... }:
{
  plugins.conform-nvim.settings = {
    # Add formatters for all languages, enhancing existing ones
    formatters_by_ft = {
      # C/C++
      c = [ "clang-format" ];
      cpp = [ "clang-format" ];
      h = [ "clang-format" ];
      hpp = [ "clang-format" ];

      # Web development (not conflicting with typescript.nix)
      html = {
        __unkeyed-1 = "prettierd";
        __unkeyed-2 = "prettier";
        stop_after_first = true;
      };
      xml = [ "xmlformat" ];
      css = {
        __unkeyed-1 = "prettierd";
        __unkeyed-2 = "prettier";
        stop_after_first = true;
      };
      scss = {
        __unkeyed-1 = "prettierd";
        __unkeyed-2 = "prettier";
        stop_after_first = true;
      };
      less = {
        __unkeyed-1 = "prettierd";
        __unkeyed-2 = "prettier";
        stop_after_first = true;
      };

      # Python
      python = {
        __unkeyed-1 = "ruff_format";
        __unkeyed-2 = "black";
        stop_after_first = true;
      };

      # Lua
      lua = [ "stylua" ];

      # Markdown
      markdown = {
        __unkeyed-1 = "prettierd";
        __unkeyed-2 = "prettier";
        stop_after_first = true;
      };

      # Config files
      toml = [ "taplo" ];
      jsonc = {
        __unkeyed-1 = "prettierd";
        __unkeyed-2 = "prettier";
        stop_after_first = true;
      };

      # SQL
      sql = [ "sql_formatter" ];

      # Docker
      dockerfile = [ "dockerfile-language-server" ];

      # Make
      make = [ "trim_whitespace" ];
      cmake = [ "cmake_format" ];

      # Enhance JavaScript/TypeScript formatters (override typescript.nix)
      javascript = lib.mkForce {
        __unkeyed-1 = "eslint_d";
        __unkeyed-2 = "prettierd";
        __unkeyed-3 = "prettier";
        stop_after_first = true;
      };
      javascriptreact = lib.mkForce {
        __unkeyed-1 = "eslint_d";
        __unkeyed-2 = "prettierd";
        __unkeyed-3 = "prettier";
        stop_after_first = true;
      };
      typescript = lib.mkForce {
        __unkeyed-1 = "eslint_d";
        __unkeyed-2 = "prettierd";
        __unkeyed-3 = "prettier";
        stop_after_first = true;
      };
      typescriptreact = lib.mkForce {
        __unkeyed-1 = "eslint_d";
        __unkeyed-2 = "prettierd";
        __unkeyed-3 = "prettier";
        stop_after_first = true;
      };
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