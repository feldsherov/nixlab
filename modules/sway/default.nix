{ config, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "foot"; 
      input = {
          "type:keyboard" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:win_space_toggle,caps:swapescape";
          };
      };
    };
  };

  home.packages = with pkgs; [
    swaylock-effects
    sway
    grim
    slurp
    wl-clipboard
  ];
}
