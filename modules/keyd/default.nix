{ config, pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings.main = {
        capslock = "esc";
        esc = "capslock";
      };
    };
  };
}
