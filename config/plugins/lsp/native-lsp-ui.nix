{ config, lib, ... }:
{
  # Native LSP UI configuration to replace lspsaga
  extraConfigLua = ''
    -- Hover handler with border
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
      }
    )

    -- Signature help with border
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "rounded",
      }
    )

    -- Diagnostic float with border
    vim.diagnostic.config({
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- Code action menu function
    _G.code_action_menu = function()
      vim.lsp.buf.code_action({
        border = "rounded",
      })
    end

    -- Rename with input
    _G.lsp_rename = function()
      local curr_name = vim.fn.expand("<cword>")
      vim.ui.input({
        prompt = "Rename: ",
        default = curr_name,
      }, function(new_name)
        if new_name then
          vim.lsp.buf.rename(new_name)
        end
      end)
    end

    -- Show line diagnostics
    _G.show_line_diagnostics = function()
      vim.diagnostic.open_float(nil, {
        focus = false,
        scope = "line",
      })
    end

    -- Show buffer diagnostics in Trouble or quickfix
    _G.show_buf_diagnostics = function()
      if pcall(require, "trouble") then
        vim.cmd("Trouble diagnostics toggle filter.buf=0")
      else
        vim.diagnostic.setloclist()
      end
    end

    -- Peek definition in float
    _G.peek_definition = function()
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
        if err then
          vim.notify("Error: " .. err.message, vim.log.levels.ERROR)
          return
        end
        if not result or vim.tbl_isempty(result) then
          vim.notify("No definition found", vim.log.levels.INFO)
          return
        end
        
        -- Get the location
        local location = result[1] or result
        local uri = location.uri or location.targetUri
        local range = location.range or location.targetRange
        
        -- Load the file content
        local bufnr = vim.uri_to_bufnr(uri)
        vim.fn.bufload(bufnr)
        
        -- Get lines around the definition
        local start_line = range.start.line
        local lines = vim.api.nvim_buf_get_lines(bufnr, math.max(0, start_line - 5), start_line + 15, false)
        
        -- Create float window
        local width = 80
        local height = #lines
        local opts = {
          relative = 'cursor',
          width = width,
          height = height,
          row = 1,
          col = 0,
          style = 'minimal',
          border = 'rounded',
        }
        
        local float_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
        
        -- Set filetype for syntax highlighting
        local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        vim.api.nvim_buf_set_option(float_buf, 'filetype', ft)
        
        local win = vim.api.nvim_open_win(float_buf, false, opts)
        
        -- Close on cursor move
        vim.api.nvim_create_autocmd({"CursorMoved", "BufLeave"}, {
          once = true,
          callback = function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end
          end
        })
      end)
    end

    -- Peek type definition
    _G.peek_type_definition = function()
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, function(err, result, ctx, config)
        if err then
          vim.notify("Error: " .. err.message, vim.log.levels.ERROR)
          return
        end
        if not result or vim.tbl_isempty(result) then
          vim.notify("No type definition found", vim.log.levels.INFO)
          return
        end
        
        -- Same logic as peek_definition but for type definition
        local location = result[1] or result
        local uri = location.uri or location.targetUri
        local range = location.range or location.targetRange
        
        local bufnr = vim.uri_to_bufnr(uri)
        vim.fn.bufload(bufnr)
        
        local start_line = range.start.line
        local lines = vim.api.nvim_buf_get_lines(bufnr, math.max(0, start_line - 5), start_line + 15, false)
        
        local width = 80
        local height = #lines
        local opts = {
          relative = 'cursor',
          width = width,
          height = height,
          row = 1,
          col = 0,
          style = 'minimal',
          border = 'rounded',
        }
        
        local float_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
        
        local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        vim.api.nvim_buf_set_option(float_buf, 'filetype', ft)
        
        local win = vim.api.nvim_open_win(float_buf, false, opts)
        
        vim.api.nvim_create_autocmd({"CursorMoved", "BufLeave"}, {
          once = true,
          callback = function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end
          end
        })
      end)
    end
  '';

  keymaps = [
    # Hover documentation (with ufo integration)
    {
      mode = "n";
      key = "K";
      action.__raw = ''
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end
      '';
      options = {
        desc = "Hover";
        silent = true;
      };
    }
    
    # Outline - use Trouble symbols or fallback to native
    {
      mode = "n";
      key = "<leader>lo";
      action.__raw = ''
        function()
          if pcall(require, "trouble") then
            vim.cmd("Trouble symbols toggle")
          else
            vim.cmd("SymbolsOutline")
          end
        end
      '';
      options = {
        desc = "Outline";
        silent = true;
      };
    }
    
    # Rename
    {
      mode = "n";
      key = "<leader>lr";
      action = "<cmd>lua lsp_rename()<CR>";
      options = {
        desc = "Rename";
        silent = true;
      };
    }
    
    # Code action
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>lua code_action_menu()<CR>";
      options = {
        desc = "Code Action";
        silent = true;
      };
    }
    
    # Buffer diagnostics
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>lua show_buf_diagnostics()<CR>";
      options = {
        desc = "Buffer Diagnostics";
        silent = true;
      };
    }
    
    # Type definition
    {
      mode = "n";
      key = "gt";
      action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
      options = {
        desc = "Type Definition";
        silent = true;
      };
    }
    
    # Peek definition
    {
      mode = "n";
      key = "gpd";
      action = "<cmd>lua peek_definition()<CR>";
      options = {
        desc = "Peek Definition";
        silent = true;
      };
    }
    
    # Peek type definition
    {
      mode = "n";
      key = "gpt";
      action = "<cmd>lua peek_type_definition()<CR>";
      options = {
        desc = "Peek Type Definition";
        silent = true;
      };
    }
    
    # Line diagnostics
    {
      mode = "n";
      key = "gl";
      action = "<cmd>lua show_line_diagnostics()<CR>";
      options = {
        desc = "Line Diagnostics";
        silent = true;
      };
    }
    
    # Diagnostic navigation (using new vim.diagnostic.jump)
    {
      mode = "n";
      key = "[d";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = -1, float = true })
        end
      '';
      options = {
        desc = "Previous Diagnostic";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = ''
        function()
          vim.diagnostic.jump({ count = 1, float = true })
        end
      '';
      options = {
        desc = "Next Diagnostic";
        silent = true;
      };
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "gp";
      mode = "n";
      group = "+peek";
    }
  ];
}