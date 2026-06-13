{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Common packages (all platforms)
    unzip
    file
    jq
    nodejs
    traceroute
    dig
    yq
    mpv
    vscode
    thunderbird
    nerd-fonts.jetbrains-mono
  ] ++ lib.optionals stdenv.isLinux [
    # Linux-only packages
    gimp
    xdg-utils
    mtr
    containerlab
  ] ++ lib.optionals stdenv.isDarwin [
    # macOS-specific packages
  ];
}
