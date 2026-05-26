{ config, pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = [ pkgs.sbctl ];

  # lanzaboote replaces the stock systemd-boot stub with a signed UKI loader.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
