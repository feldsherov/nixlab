{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    swaylock-effects
    sway
    grim
    slurp
    wl-clipboard
  ];
}
