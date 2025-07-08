# Final fix: Completely disable preview for Haskell files
# Since crashes occur even without treesitter, we need to avoid previewing these files entirely
{ config, lib, ... }:
{
  # Override telescope to skip preview for Haskell files
  plugins.telescope.settings = {
    defaults = {
      file_previewer.__raw = ''
        function(opts)
          local previewers = require("telescope.previewers")
          local from_entry = require("telescope.from_entry")
          
          return previewers.new_buffer_previewer({
            title = "File Preview",
            get_buffer_by_name = function(_, entry)
              return from_entry.path(entry, false)
            end,
            
            define_preview = function(self, entry, status)
              local filepath = from_entry.path(entry, false)
              if not filepath then return end
              
              -- Check if it's a Haskell file
              if filepath:match("%.hs$") or filepath:match("%.lhs$") or filepath:match("%.hsc$") then
                -- Don't preview Haskell files, show a message instead
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
                  "",
                  "  Haskell File Preview Disabled",
                  "",
                  "  File: " .. vim.fn.fnamemodify(filepath, ":t"),
                  "  Size: " .. (vim.fn.getfsize(filepath) or 0) .. " bytes",
                  "",
                  "  (Preview disabled to prevent crashes)",
                  "",
                  "  Press <Enter> to open the file",
                })
                vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "text")
                return
              end
              
              -- For non-Haskell files, use normal preview
              require("telescope.previewers").buffer_previewer_maker(filepath, self.state.bufnr, opts)
            end,
          })
        end
      '';
      
      grep_previewer.__raw = ''
        function(opts)
          local previewers = require("telescope.previewers")
          
          return previewers.new_buffer_previewer({
            title = "Grep Preview",
            
            define_preview = function(self, entry, status)
              -- Check if it's a Haskell file
              if entry.filename and (entry.filename:match("%.hs$") or 
                                   entry.filename:match("%.lhs$") or 
                                   entry.filename:match("%.hsc$")) then
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
                  "",
                  "  Haskell File Preview Disabled",
                  "",
                  "  Match found in: " .. entry.filename,
                  "  Line " .. (entry.lnum or "?") .. ": " .. (entry.text or ""),
                  "",
                  "  (Preview disabled to prevent crashes)",
                })
                return
              end
              
              -- For non-Haskell files, use normal grep preview
              require("telescope.config").values.grep_previewer(opts):define_preview(self, entry, status)
            end,
          })
        end
      '';
    };
  };

  # Additional safety: Set up a keymap to toggle preview
  keymaps = [
    {
      mode = "n";
      key = "<leader>fp";
      action.__raw = ''
        function()
          local telescope = require("telescope")
          local current_picker = require("telescope.actions.state").get_current_picker(vim.api.nvim_get_current_buf())
          
          if current_picker then
            -- Toggle preview in current picker
            if current_picker.previewer then
              current_picker.previewer = nil
              print("Preview disabled")
            else
              print("Preview enabled")
            end
          else
            -- Toggle default preview setting
            if telescope.defaults.preview == false then
              telescope.defaults.preview = true
              print("Telescope preview enabled by default")
            else
              telescope.defaults.preview = false
              print("Telescope preview disabled by default")
            end
          end
        end
      '';
      options = {
        desc = "Toggle telescope preview";
      };
    }
  ];

  # Quick command to search without preview
  extraConfigLua = ''
    vim.api.nvim_create_user_command("TelescopeNoPreview", function(opts)
      require("telescope.builtin")[opts.args]({ previewer = false })
    end, {
      nargs = 1,
      complete = function()
        return {
          "find_files",
          "live_grep", 
          "buffers",
          "help_tags",
          "oldfiles",
          "git_files",
        }
      end,
    })
    
    -- Helpful message when in Haskell projects
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/stack.yaml") == 1 or 
           vim.fn.filereadable(cwd .. "/cabal.project") == 1 or
           vim.fn.glob(cwd .. "/*.cabal") ~= "" then
          vim.notify("In Haskell project - use :TelescopeNoPreview find_files to avoid crashes", vim.log.levels.INFO)
        end
      end
    })
  '';
}