{ pkgs, ... }:
{
  extraPackages = with pkgs; [ lazygit ];

  plugins.snacks = {
    settings = {
      lazygit.enabled = true;
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>gl";
      action = ":lua Snacks.lazygit.open()<CR>";
      options = {
        desc = "Open LazyGit";
      };
    }
  ];
}
