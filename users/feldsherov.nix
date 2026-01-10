{ config, pkgs, ... }:

{
  home.username = "feldsherov";
  home.homeDirectory = "/home/feldsherov";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  imports = [
    ../modules/sway/default.nix
    ../modules/vim/default.nix
  ];

  home.packages = with pkgs; [
    vscode
    file
    gimp
    dejavu_fonts
    xdg-utils
    jq
    nodejs
    tmux
    mpv
    traceroute
    mtr
    dig
  ];

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Svyatoslav Feldsherov";
        email = "svyat@feldsherov.name";
      };
      core.editor = "nvim";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

