{ config, pkgs, ... }:

let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });
in {
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
  ];

  home.packages = with pkgs; [
    vscode
    gimp
    tex
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName  = "Svyatoslav Feldsherov";
    userEmail = "svyat@feldsherov.name";
  };
}

