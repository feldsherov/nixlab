{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    terminal = "tmux-256color";
    extraConfig = ''
      set -s extended-keys always
      set -as terminal-features 'xterm*:extkeys'

      # Shift+Enter sends Escape+Enter for multiline input in apps like Claude Code
      bind -n S-Enter send-keys Escape Enter
    '';
  };
}
