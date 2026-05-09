# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/misc-packages/default.nix
    ../../modules/keyd/default.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Dump kernel cores (hopefully)
  boot.crashDump.enable = true;


  fonts.packages = with pkgs; [
    meslo-lgs-nf
  ];

  networking.hostName = "newt"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.feldsherov = {
    isNormalUser = true;
    description = "Svyatoslav Feldsherov";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  # Enable zsh system-wide (required for it to be a valid login shell)
  programs.zsh.enable = true;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System wide packages
  environment.systemPackages = with pkgs; [
    vim 
    firefox
    git
    htop
    flex
    python3
    bison
    pavucontrol
    docker
    wireshark
    vlc
    zoom
    openssl
    openssl.dev
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };



  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };


  # Use Ozon platform abstruction layer in Chrome.
  # Fixes blury VsCode issue for me.
  # https://www.reddit.com/r/hyprland/comments/1828qts/waybar_workspaces_on_nixos_and_blurry_vscode/
  # This semantically belongs to Sway module under feldsherov.nix, but
  # I failed to set enviroment variable from Sway from Home Manger context.
  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  security.polkit.enable = true;
  hardware.graphics.enable = true;

  services.gnome.gnome-keyring.enable=true;

  # Host-specific Home Manager settings
  home-manager.backupFileExtension = "backup";
  home-manager.users.feldsherov = {
    imports = [
      ../../modules/sway/default.nix
    ];

    programs.kitty = {
      enable = true;
      font = {
        name = "MesloLGS NF";
      };
      settings = {
        # Hipster Green color scheme
        background = "#100b05";
        foreground = "#84c138";
        cursor = "#23ff18";
        selection_background = "#083905";
        selection_foreground = "#ffffff";

        # Normal colors
        color0 = "#000000";
        color1 = "#b6214a";
        color2 = "#00a600";
        color3 = "#bfbf00";
        color4 = "#246eb2";
        color5 = "#b200b2";
        color6 = "#00a6b2";
        color7 = "#bfbfbf";

        # Bright colors
        color8 = "#666666";
        color9 = "#e50000";
        color10 = "#86a93e";
        color11 = "#e5e500";
        color12 = "#0000ff";
        color13 = "#e500e5";
        color14 = "#00e5e5";
        color15 = "#e5e5e5";
      };
      extraConfig = ''
        # Send CSI u sequence for Shift+Enter so tmux can recognize it
        map shift+enter send_text all \x1b[13;2u
      '';
    };

    services.batsignal = {
      enable = true;
      extraArgs = [
        "-w" "20"   # warning at 20%
        "-c" "10"   # critical at 10%
        "-d" "5"    # danger at 5%
      ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # PDF
        "application/pdf" = "firefox.desktop";
        # Images
        "image/jpeg" = "firefox.desktop";
        "image/png" = "firefox.desktop";
        "image/gif" = "firefox.desktop";
        "image/webp" = "firefox.desktop";
        "image/bmp" = "firefox.desktop";
        "image/svg+xml" = "firefox.desktop";
        "image/tiff" = "firefox.desktop";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Enable flakes.
  # https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
       experimental-features = nix-command flakes
    '';
  };

}
