{ config, pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  programs.firefox = {
    enable = true;

    # Developer Edition is one of the few channels (with Nightly/ESR/unbranded)
    # that honors xpinstall.signatures.required, so unsigned / locally-built
    # extensions can be installed permanently.
    package = pkgs.firefox-devedition;

    profiles.dev = {
      # id 0 makes this the default profile automatically.
      id = 0;
      settings = {
        # Allow installing unsigned add-ons (e.g. a local .xpi or unpacked
        # folder via about:debugging -> "Load Temporary Add-on").
        "xpinstall.signatures.required" = false;
      };
    };
  };
}
