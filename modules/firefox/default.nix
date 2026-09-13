{ config, pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  programs.firefox = {
    enable = true;
  };
}
