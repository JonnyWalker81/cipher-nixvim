# Extended formatter configuration for all common programming languages
{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    settings = {
      formatters_by_ft = {
        # C/C++ formatting
        c = [ "clang-format" ];
        cpp = [ "clang-format" ];
        
        # Web development
        html = [[ "prettierd" "prettier" ]];
        css = [[ "prettierd" "prettier" ]];
        scss = [[ "prettierd" "prettier" ]];
        less = [[ "prettierd" "prettier" ]];
        
        # JavaScript/TypeScript (extends existing)
        javascript = [[ "prettierd" "prettier" "eslint_d" ]];
        javascriptreact = [[ "prettierd" "prettier" "eslint_d" ]];
        typescript = [[ "prettierd" "prettier" "eslint_d" ]];
        typescriptreact = [[ "prettierd" "prettier" "eslint_d" ]];
        vue = [[ "prettierd" "prettier" ]];
        
        # Python
        python = [[ "ruff_format" "black" ]];
        
        # Ruby
        ruby = [ "rubocop" ];
        
        # PHP
        php = [ "php_cs_fixer" ];
        
        # Lua
        lua = [ "stylua" ];
        
        # Markdown
        markdown = [[ "prettierd" "prettier" ]];
        
        # XML
        xml = [ "xmlformat" ];
        
        # Java
        java = [ "google-java-format" ];
        
        # Kotlin
        kotlin = [ "ktlint" ];
        
        # Swift
        swift = [ "swiftformat" ];
        
        # Scala
        scala = [ "scalafmt" ];
        
        # SQL
        sql = [ "sql_formatter" ];
        
        # Docker
        dockerfile = [ "dockerfile-language-server" ];
        
        # TOML
        toml = [ "taplo" ];
        
        # Protobuf
        proto = [ "buf" ];
        
        # GraphQL
        graphql = [[ "prettierd" "prettier" ]];
        
        # Jsonnet
        jsonnet = [ "jsonnetfmt" ];
      };
      
      # Define formatter commands
      formatters = {
        clang_format = {
          command = "${pkgs.clang-tools}/bin/clang-format";
          args = [ "--style=file" ];
        };
        
        ruff_format = {
          command = "${pkgs.ruff}/bin/ruff";
          args = [ "format" "-" ];
        };
        
        black = {
          command = "${pkgs.black}/bin/black";
          args = [ "--quiet" "-" ];
        };
        
        stylua = {
          command = "${pkgs.stylua}/bin/stylua";
          args = [ "-" ];
        };
        
        rubocop = {
          command = "${pkgs.rubyPackages.rubocop}/bin/rubocop";
          args = [ "--stdin" "$FILENAME" "-a" "--stderr" "--fail-level" "fatal" ];
          stdin = true;
        };
        
        php_cs_fixer = {
          command = "${pkgs.php83Packages.php-cs-fixer}/bin/php-cs-fixer";
          args = [ "fix" "$FILENAME" ];
          stdin = false;
        };
        
        xmlformat = {
          command = "${pkgs.xmlformat}/bin/xmlformat";
          args = [ "-" ];
        };
        
        google_java_format = {
          command = "${pkgs.google-java-format}/bin/google-java-format";
          args = [ "-" ];
        };
        
        ktlint = {
          command = "${pkgs.ktlint}/bin/ktlint";
          args = [ "--format" ];
          stdin = true;
        };
        
        swiftformat = {
          command = "${pkgs.swiftformat}/bin/swiftformat";
          stdin = true;
        };
        
        scalafmt = {
          command = "${pkgs.scalafmt}/bin/scalafmt";
          args = [ "--stdin" ];
        };
        
        sql_formatter = {
          command = "${pkgs.nodePackages.sql-formatter}/bin/sql-formatter";
        };
        
        taplo = {
          command = "${pkgs.taplo}/bin/taplo";
          args = [ "format" "-" ];
        };
        
        buf = {
          command = "${pkgs.buf}/bin/buf";
          args = [ "format" "-w" ];
          stdin = true;
        };
        
        jsonnetfmt = {
          command = "${pkgs.jsonnet}/bin/jsonnetfmt";
          args = [ "-" ];
        };
      };
    };
  };
  
  # Add necessary packages
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
    google-java-format
    ktlint
    taplo
    jsonnet
    
    # Note: Some formatters may need to be added to your system packages
    # or project-specific shells (ruby, php, swift, scala)
  ];
}