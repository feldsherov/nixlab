{ config, pkgs, lib, ... }:

{
  home.file.".claude/settings.json".text = builtins.toJSON {
    includeCoAuthoredBy = false;
  };
}
