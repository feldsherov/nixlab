{ config, pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "kitty";
      	menu = ''
          bemenu-run --tf '#ff9900' --hf '#ff9900' --ignorecase --list 10 --prompt "$:"
        '';
        input = {
           "type:keyboard" = {
            xkb_layout = "us,ru,il";
            xkb_options = "grp:win_space_toggle,caps:swapescape";
           };
           "type:touchpad" = {
  	        natural_scroll = "enabled";
           };
        };
        left = "h";
        right = "l";
        down = "j";
        up = "k";
        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";

          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

          "${modifier}+Shift+1" =
            "move container to workspace number 1";
          "${modifier}+Shift+2" =
            "move container to workspace number 2";
          "${modifier}+Shift+3" =
            "move container to workspace number 3";
          "${modifier}+Shift+4" =
            "move container to workspace number 4";
          "${modifier}+Shift+5" =
            "move container to workspace number 5";
          "${modifier}+Shift+6" =
            "move container to workspace number 6";
          "${modifier}+Shift+7" =
            "move container to workspace number 7";
          "${modifier}+Shift+8" =
            "move container to workspace number 8";
          "${modifier}+Shift+9" =
            "move container to workspace number 9";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec sway exit";

          "${modifier}+r" = "mode resize";
          "${modifier}+z" = "exec swaylock " +
             " --screenshots --clock --indicator" +
             " --indicator-radius 100 --indicator-thickness 7" +
             " --effect-blur 7x5 --effect-vignette 0.5:0.5" +
             " --ring-color 00ff88 --key-hl-color 880033" +
             " --line-color 00000000 --inside-color 00000088" +
             " --separator-color 00000000 --grace 2 --fade-in 0.2";
        };

      bars = [{
        mode = "dock";
        hiddenState = "hide";
        position = "top";
        workspaceButtons = true;
        workspaceNumbers = true;
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        fonts = {
          names = [ "monospace" ];
          size = 8.0;
        };
        trayOutput = "primary";
        colors = {
          background = "#000000";
          statusline = "#ffffff";
          separator = "#666666";
          focusedWorkspace = {
            border = "#4c7899";
            background = "#285577";
            text = "#ffffff";
          };
          activeWorkspace = {
            border = "#333333";
            background = "#5f676a";
            text = "#ffffff";
          };
          inactiveWorkspace = {
            border = "#333333";
            background = "#222222";
            text = "#888888";
          };
          urgentWorkspace = {
            border = "#2f343a";
            background = "#900000";
            text = "#ffffff";
          };
          bindingMode = {
            border = "#2f343a";
            background = "#900000";
            text = "#ffffff";
            };
        };
      }];
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            block = "keyboard_layout";
            driver = "sway";
            mappings = {
              "English (US)" = "US";
              "Russian" = "RU";
              "Hebrew" = "IL";
            };
          }
          {
            block = "net";
            format = " $ssid $signal_strength $ip ";
          }
          {
            block = "cpu";
            interval = 5;
            format = " CPU $utilization ";
          }
          {
            block = "memory";
            format = " MEM $mem_used_percents ";
          }
          {
            block = "battery";
            format = " BAT $percentage ";
          }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
          }
        ];
        settings = {
          theme = {
            theme = "plain";
          };
        };
        icons = "none";
      };
    };
  };

  home.packages = with pkgs; [
    i3status-rust
    bemenu
    swaylock-effects
    grim
    slurp
    wl-clipboard
    mako        # notification daemon
    libnotify   # notify-send command
  ];

  services.mako = {
    enable = true;
    settings.default-timeout = 10000;  # 10 seconds
  };
}
