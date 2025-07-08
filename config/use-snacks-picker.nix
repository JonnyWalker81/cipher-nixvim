# Switch from telescope to snacks as the default file picker
{ config, lib, ... }:
{
  # Re-enable snacks picker for file operations
  keymaps = lib.mkAfter [
    # Override telescope keymaps with snacks
    {
      mode = "n";
      key = "<leader><leader>";
      action = ''<cmd>lua Snacks.picker.files({hidden = true})<cr>'';
      options = {
        desc = "Find files (Snacks)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader><space>";
      action = ''<cmd>lua Snacks.picker.files({hidden = true})<cr>'';
      options = {
        desc = "Find files (Snacks)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>/";
      action = ''<cmd>lua Snacks.picker.grep()<cr>'';
      options = {
        desc = "Live grep (Snacks)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>bb";
      action = ''<cmd>lua Snacks.picker.buffers({ sort_lastused = true })<cr>'';
      options = {
        desc = "Find buffers (Snacks)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = ''<cmd>lua Snacks.picker.recent()<cr>'';
      options = {
        desc = "Recent files (Snacks)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = ''<cmd>lua Snacks.picker.files({hidden = true})<cr>'';
      options = {
        desc = "Find files (Snacks)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = ''<cmd>lua Snacks.picker.grep()<cr>'';
      options = {
        desc = "Live grep (Snacks)";
        silent = true;
      };
    }
    
    # Keep some telescope commands that don't have snacks equivalents
    {
      mode = "n";
      key = "<leader>fT";
      action = "<cmd>Telescope colorscheme<cr>";
      options = {
        desc = "Colorscheme (Telescope)";
        silent = true;
      };
    }
  ];

  # Disable telescope lazy loading to avoid conflicts
  plugins.telescope.lazyLoad.enable = lib.mkForce false;

  # Add a toggle command to switch between pickers
  extraConfigLua = ''
    -- Command to toggle between snacks and telescope
    vim.g.use_snacks_picker = true
    
    vim.api.nvim_create_user_command("TogglePicker", function()
      vim.g.use_snacks_picker = not vim.g.use_snacks_picker
      local picker = vim.g.use_snacks_picker and "Snacks" or "Telescope"
      vim.notify("Now using " .. picker .. " for file picking", vim.log.levels.INFO)
    end, { desc = "Toggle between Snacks and Telescope pickers" })
    
    -- Helper function to use the selected picker
    _G.smart_find_files = function()
      if vim.g.use_snacks_picker then
        Snacks.picker.files({hidden = true})
      else
        require('telescope.builtin').find_files({hidden = true})
      end
    end
    
    _G.smart_grep = function()
      if vim.g.use_snacks_picker then
        Snacks.picker.grep()
      else
        require('telescope.builtin').live_grep()
      end
    end
  '';
}