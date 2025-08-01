# Malloc debugging configuration
# This adds environment variables to help debug malloc errors

{ pkgs, ... }:
{
  # Add malloc debugging environment variables
  extraPackages = with pkgs; [
    gdb  # For analyzing core dumps
  ];

  # Set environment variables for malloc debugging
  extraConfigLuaPre = ''
    -- Set malloc debugging environment variables
    vim.env.MALLOC_CHECK_ = "3"  -- Enable malloc debugging
    vim.env.MALLOC_PERTURB_ = "1"  -- Fill freed memory with garbage
    
    -- Log when Neovim starts
    local log = io.open("/tmp/nvim-startup.log", "a")
    if log then
      log:write(os.date("%Y-%m-%d %H:%M:%S") .. " - Neovim started with PID: " .. vim.fn.getpid() .. "\n")
      log:close()
    end
    
    -- Set up autocmd to log before potential crash
    vim.api.nvim_create_autocmd("CmdlineEnter", {
      callback = function()
        local cmd = vim.fn.getcmdline()
        if cmd:match("^[xX]") then
          local log = io.open("/tmp/nvim-x-search.log", "a")
          if log then
            log:write(os.date("%Y-%m-%d %H:%M:%S") .. " - Searching for: " .. cmd .. "\n")
            log:close()
          end
        end
      end
    })
  '';
}