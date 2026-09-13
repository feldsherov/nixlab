# Dropbox — Home Manager module (Linux-only; the Home Manager `services.dropbox`
# module is not available on Darwin).
#
# The module runs the sync daemon as a systemd user service with
# HOME=~/.dropbox-hm, so Dropbox's state and its sync folder live under
# ~/.dropbox-hm/ instead of scattering into the real home directory. The actual
# sync folder is therefore ~/.dropbox-hm/Dropbox, not ~/Dropbox.
#
# First launch requires interactive account linking: watch the URL in
# `journalctl --user -u dropbox -f` and open it while logged in.
#
# Note: the `dropbox-cli` package (system-wide, in modules/misc-packages) and
# the `dropbox` shell alias (modules/zsh) point the CLI at this daemon's HOME.
{ config, lib, pkgs, ... }:

{
  services.dropbox.enable = true;

  # Expose the real sync folder at the conventional ~/Dropbox path.
  home.file."Dropbox".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dropbox-hm/Dropbox";
}
