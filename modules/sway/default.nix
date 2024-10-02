{ config, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
  };

  home.packages = with pkgs; [
    swaylock-effects
    sway
    grim
    slurp
    wl-clipboard
  ];
}
