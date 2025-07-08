{
  config,
  lib,
  pkgs,
  ...
}:

{
  plugins.supermaven = {
    enable = true;
    settings = {
      keymaps = {
        accept_suggestion = "<C-y>";
        clear_suggestion = "<C-{>";
        accept_word = "<C-w>";
      };
      log_level = "info";
      disable_inline_completion = false;
      disable_keymaps = false;
    };
    
    lazyLoad = {
      enable = lib.mkDefault true;
      settings = {
        event = [ "InsertEnter" ];
        cmd = [ "SupermavenStart" "SupermavenStop" "SupermavenRestart" "SupermavenToggle" "SupermavenUseFree" "SupermavenUsePro" "SupermavenShowLog" "SupermavenClearLog" "SupermavenStatus" ];
      };
    };
  };
}
