{ config, pkgs, lib, ... }:

{
  home.username = "feldsherov";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/feldsherov"
    else "/home/feldsherov";

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
    ../modules/vim/default.nix
    ../modules/sway/default.nix
  ];


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

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    terminal = "tmux-256color";
    extraConfig = ''
      set -s extended-keys always
      set -as terminal-features 'xterm*:extkeys'

      # Shift+Enter sends Escape+Enter for multiline input in apps like Claude Code
      bind -n S-Enter send-keys Escape Enter
    '';
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "minimal";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "MesloLGS NF";
    };
    extraConfig = ''
      # Send CSI u sequence for Shift+Enter so tmux can recognize it
      map shift+enter send_text all \x1b[13;2u
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services.batsignal = {
    enable = true;
    extraArgs = [
      "-w" "20"   # warning at 20%
      "-c" "10"   # critical at 10%
      "-d" "5"    # danger at 5%
    ];
  };
}

