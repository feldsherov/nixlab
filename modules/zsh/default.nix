{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "minimal";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
