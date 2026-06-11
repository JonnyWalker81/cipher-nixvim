{ pkgs, lib, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # default_format_opts.lsp_format = "prefer";
      # format_on_save = {
      #   lspFallback = true;
      #   timeoutMs = 500;
      # };
      # format_after_save = {
      #   timeoutMs = 500;
      #   lspFallback = true;
      # };
      format_on_save = ''
        function(bufnr)
            local filetype = vim.bo[bufnr].filetype
            if filetype == "html" then
              return { timeoutMs = 1000, lspFallback = true }
            else
              return { timeoutMs = 500, lspFallback = true }
            end
          end
      '';

      format_after_save = ''
        function(bufnr)
            local filetype = vim.bo[bufnr].filetype
            if filetype ~= "html" then
              return { timeoutMs = 1000, lspFallback = true }
            else
              return { timeoutMs = 500, lspFallback = true }
            end
          end
      '';

      formatters_by_ft = {
        # Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];

        sql = [ "sql_formatter" ];

        # html = {
        #   __unkeyed-1 = "prettierd";
        #   __unkeyed-2 = "prettier";
        #   # timeout_ms = 500;
        #   stop_after_first = true;
        # };

        # typescript = {
        #   __unkeyed-1 = "prettierd";
        #   __unkeyed-2 = "prettier";
        #   stop_after_first = true;
        # };
      };
      formatters = {
        sql_formatter = {
          command = lib.getExe pkgs.sql-formatter;
          prepend_args = [
            "--language"
            "postgresql"
            "--config"
            (builtins.toJSON { useTabs = true; })
          ];
        };
      };
      # formatters = {
      #   _ = {
      #     command = "${pkgs.gawk}/bin/gawk";
      #   };
      #   squeeze_blanks = {
      #     command = lib.getExe' pkgs.coreutils "cat";
      #   };
      #   prettierd.command = lib.getExe pkgs.prettierd;
      #   prettier.command = lib.getExe pkgs.nodePackages.prettier;
      # };
    };
  };

  # Treat Go raw strings that start with a SQL keyword as embedded SQL so
  # conform's "injected" formatter (and treesitter highlighting) can handle them.
  extraFiles."after/queries/go/injections.scm".text =
    let
      sqlKeywords = [
        "WITH"
        "SELECT"
        "INSERT"
        "UPDATE"
        "DELETE"
        "CREATE"
        "ALTER"
        "DROP"
      ];
      mkPattern = kw: ''
        ((raw_string_literal_content) @injection.content
          (#lua-match? @injection.content "^%s*${kw}%s")
          (#set! injection.language "sql"))
      '';
    in
    ''
      ;; extends

      ${lib.concatMapStringsSep "\n" mkPattern sqlKeywords}
    '';

  # Format embedded code (treesitter-injected regions, e.g. SQL strings). In Go
  # buffers, guarantee the formatted strings are indented purely with tabs:
  # conform's injected formatter re-applies whatever whitespace prefix the
  # region originally had (or none, when lines share no common prefix), so
  # instead we dedent the region fully before formatting and then prepend the
  # opening line's tab indentation to every line of the output. Leading
  # whitespace inside these regions is non-semantic for formatted languages.
  extraConfigLua = ''
    -- Multi-line Go raw strings that contain a treesitter-injected language
    -- (e.g. the SQL strings matched by our injections.scm). Returns a list of
    -- { open = row_with_opening_backtick, first = first_content_row,
    --   last = last_content_row } (0-indexed, inclusive). The host
    -- raw_string_literal_content node starts right after the backtick, so its
    -- start row is the opening line; injected tree ranges start at the first
    -- token instead, so they are only used to select which strings qualify.
    local function go_injected_strings(bufnr)
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
      if not ok or not parser or parser:lang() ~= "go" then
        return {}
      end
      parser:parse(true)
      local spans = {}
      for _, child in pairs(parser:children()) do
        for _, tree in ipairs(child:trees()) do
          local sr, _, er = tree:root():range()
          table.insert(spans, { sr, er })
        end
      end
      if #spans == 0 then
        return {}
      end
      local results = {}
      local query = vim.treesitter.query.parse("go", "(raw_string_literal_content) @c")
      local root = parser:trees()[1]:root()
      for _, node in query:iter_captures(root, bufnr) do
        local sr, _, er = node:range()
        if er > sr then
          for _, sp in ipairs(spans) do
            if sp[1] >= sr and sp[2] <= er then
              table.insert(results, { open = sr, first = sr + 1, last = er })
              break
            end
          end
        end
      end
      return results
    end

    function _G.FormatEmbedded()
      local bufnr = vim.api.nvim_get_current_buf()
      local is_go = vim.bo[bufnr].filetype == "go"

      if is_go then
        -- Normalize strings whose content starts right after the opening
        -- backtick (`INSERT INTO ...) to the canonical shape with the SQL on
        -- its own line, so the indent passes below see every content line.
        -- Iterate bottom-up: inserting a newline shifts later rows.
        local glued = {}
        for _, r in ipairs(go_injected_strings(bufnr)) do
          local line = vim.api.nvim_buf_get_lines(bufnr, r.open, r.open + 1, false)[1] or ""
          local tick = line:find("`")
          if tick and line:sub(tick + 1):match("%S") then
            table.insert(glued, { row = r.open, col = tick })
          end
        end
        table.sort(glued, function(a, b) return a.row > b.row end)
        for _, g in ipairs(glued) do
          vim.api.nvim_buf_set_text(bufnr, g.row, g.col, g.row, g.col, { "", "" })
        end

        -- Dedent the string contents so conform has no whitespace prefix to
        -- restore afterwards. Leading whitespace is non-semantic in the
        -- injected languages we format; the formatter rebuilds the structure.
        for _, r in ipairs(go_injected_strings(bufnr)) do
          local lines = vim.api.nvim_buf_get_lines(bufnr, r.first, r.last + 1, false)
          for i, l in ipairs(lines) do
            lines[i] = l:gsub("^[ \t]+", "")
          end
          vim.api.nvim_buf_set_lines(bufnr, r.first, r.last + 1, false, lines)
        end
      end

      require("conform").format({ formatters = { "injected" }, timeout_ms = 5000, async = false })

      if is_go then
        -- Re-indent each formatted string purely with tabs, one level deeper
        -- than the line that opens the string (ranges re-collected because
        -- formatting changes line counts).
        for _, r in ipairs(go_injected_strings(bufnr)) do
          local opening = vim.api.nvim_buf_get_lines(bufnr, r.open, r.open + 1, false)[1] or ""
          local base = opening:match("^\t*") or ""
          local lines = vim.api.nvim_buf_get_lines(bufnr, r.first, r.last + 1, false)
          for i, l in ipairs(lines) do
            if l ~= "" then
              lines[i] = base .. l
            end
          end
          vim.api.nvim_buf_set_lines(bufnr, r.first, r.last + 1, false, lines)
        end
      end
    end
  '';

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format()<cr>";
      options = {
        silent = true;
        desc = "Format";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cF";
      action = "<cmd>lua FormatEmbedded()<cr>";
      options = {
        silent = true;
        desc = "Format embedded code (SQL strings etc.)";
      };
    }
  ];
}
