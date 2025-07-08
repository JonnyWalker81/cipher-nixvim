# Temporary debug configuration for malloc error investigation
# This file contains various configurations to help diagnose the malloc error
# when searching for files starting with "x" using snacks/telescope

{ config, lib, ... }:
{
  # Option 1: Disable snacks picker for file search, use telescope only
  # Uncomment to test:
  # plugins.snacks.settings.picker.enabled = false;

  # Option 2: Disable telescope completely to isolate the issue
  # Uncomment to test:
  # plugins.telescope.enable = false;

  # Option 3: Try using a different matcher algorithm
  # plugins.snacks.settings.picker.matcher = {
  #   frecency = false;
  #   fuzzy = true;
  # };

  # Option 4: Limit memory usage with file pattern exclusions
  # plugins.snacks.settings.picker.files = {
  #   exclude = [
  #     "*.x*"  # Temporarily exclude files starting with x
  #   ];
  # };

  # Option 5: Add more aggressive garbage collection
  # extraConfigLua = ''
  #   vim.opt.updatetime = 100
  #   vim.api.nvim_create_autocmd("CursorHold", {
  #     callback = function()
  #       collectgarbage("collect")
  #     end
  #   })
  # '';
}