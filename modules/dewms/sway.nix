{
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  scriptsdir = "/home/xllvr/repos/scripts";

  primaryscreen = "DP-2";
  secondaryscreen = "DP-3";
in {
  imports = [
    ../apps/os/waybar.nix
  ];

  waybar.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    config = {
      ## Hardware
      output = {
        DP-2 = {
          mode = "1920x1080";
          pos = "0 0";
        };
        DP-3 = {
          mode = "1680x1050";
          pos = "1920 0";
        };
      };
      input = {
        "1390:268:ELECOM_TrackBall_Mouse_HUGE_TrackBall" = {
          scroll_button = "277";
          scroll_button_lock = "enabled";
          scroll_method = "on_button_down";
        };
      };

      ## Keybinds
      modifier = mod;
      keybindings = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (map (num: let
          ws = toString num;
        in {
          "${mod}+${ws}" = "workspace ${ws}";
          "${mod}+Shift+${ws}" = "move container to workspace ${ws}";
        }) [1 2 3 4 5 6 7 8 9 0]))

        (lib.attrsets.concatMapAttrs (key: direction: {
            "${mod}+${key}" = "focus ${direction}";
            "${mod}+Ctrl+${key}" = "move ${direction}";
            "${mod}+Shift+${key}" = "move workspace to output ${direction}";
          }) {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          })

        {
          "${mod}+Return" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty";
          "Alt+space" = "exec --no-startup-id fuzzel";

          "${mod}+c" = "kill";
          "${mod}+Alt+o" = "exec systemctl poweroff";
          "${mod}+Alt+r" = "exec systemctl reboot";
          "${mod}+Alt+s" = "exec systemctl suspend";

          "${mod}+a" = "focus parent";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+z" = "floating toggle";
          "${mod}+g" = "split h";
          "${mod}+v" = "split v";
          "${mod}+x" = "layout toggle split";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "${mod}+Ctrl+q" = "exit";

          "${mod}+Alt+v" = "exec ${scriptsdir}/fuzzclip";
          "${mod}+Shift+s" = "exec ${scriptsdir}/fuzzshot";

          "${mod}+Alt+f" = "exec thunar";
          "${mod}+b" = "exec ${pkgs.librewolf}/bin/librewolf";
          "${mod}+e" = "exec kitty --detach yazi";
        }
      ];
      focus.followMouse = true;

      ## Startup
      startup = [
        {
          command = "mako";
          always = true;
        }
        {command = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";}
        {command = "syncthing";}
        {command = "kitty --detach musikcube";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store";}
        {command = "bluetoothctl trust 28:D0:EA:94:0C:A9";}
        {command = "bluetoothctl power on";}
        {command = "bluetoothctl connect 28:D0:EA:94:0C:A9";}
        {command = "fcitx5 -d --replace";}
        {command = "fcitx5-remote -r";}
        {command = "${pkgs.openssh}/bin/ssh-add $HOME/.ssh/github_rsa";}
        {command = "${pkgs.librewolf}/bin/librewolf";}
        {command = "${pkgs.safeeyes}/bin/safeeyes";}
      ];
      workspaceAutoBackAndForth = true;

      ## Window Rules
      floating = {
        titlebar = false;
        border = 3;
        criteria = [
          {class = "nmtui";}
          {class = "Pavucontrol";}
          {class = ".*mako.*";}
          {class = ".*blueman.*";}
          {title = "Steam - Update News";}
        ];
      };
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "${primaryscreen}";
        }
        {
          workspace = "7";
          output = "${primaryscreen}";
        }
        {
          workspace = "2";
          output = "${secondaryscreen}";
        }
        {
          workspace = "6";
          output = "${secondaryscreen}";
        }
      ];
      assigns = {
        "1" = [{title = "^Discord.*";}];
        "2" = [{title = "^Firefox$";}];
        "6" = [{class = "obsidian";}];
        "7" = [{title = "^musikcube$";}];
      };
      window = {
        border = 3;
        titlebar = false;
      };

      ## Aesthetics
      gaps = {
        inner = 5;
        outer = 10;
      };

      ## Bars
      bars = [
        {
          position = "top";
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };
}
