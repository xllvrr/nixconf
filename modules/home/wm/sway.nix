{
  pkgs,
  config,
  lib,
  ...
}: let
  mod = "Mod4";

  primaryscreen = "DP-1";
  secondaryscreen = "HDMI-A-1";
  configHome =
    if config.xdg.enable or false
    then config.xdg.configHome
    else "${config.home.homeDirectory}/.config";
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      ## Hardware
      output = {
        DP-1 = {
          mode = "1920x1080";
          pos = "0 0";
        };
        HDMI-A-1 = {
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
          "Alt+space" = "exec --no-startup-id ${pkgs.bash}/bin/bash -lc 'noctalia-shell ipc call launcher toggle || fuzzel'";

          "${mod}+c" = "kill";
          # "${mod}+Alt+o" = "exec systemctl poweroff";
          # "${mod}+Alt+r" = "exec systemctl reboot";
          # "${mod}+Alt+s" = "exec systemctl suspend";

          "${mod}+a" = "focus parent";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+z" = "floating toggle";
          "${mod}+g" = "split h";
          "${mod}+v" = "split v";
          "${mod}+x" = "layout toggle split";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";

          "${mod}+m" = "move scratchpad";
          "${mod}+Shift+m" = "scratchpad show";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "${mod}+Ctrl+q" = "exit";

          "${mod}+Alt+v" = "exec ${pkgs.bash}/bin/bash -lc 'noctalia-shell ipc call launcher clipboard || fuzzclip'";
          "${mod}+Shift+s" = "exec fuzzshot";

          "${mod}+Alt+f" = "exec thunar";
          "${mod}+b" = "exec ${pkgs.firefox}/bin/firefox";
          "${mod}+e" = "exec kitty --detach yazi";
          "${mod}+r" = "exec record-audio";
        }
      ];
      focus.followMouse = true;

      ## Startup
      startup = [
        {
          # Work around a Qt6 + fcitx5-qt crash (segfault in libfcitx5platforminputcontextplugin.so).
          command = "env QT_IM_MODULE= noctalia-shell";
        }
        {command = "syncthing";}
        {command = "${pkgs.kitty}/bin/kitty --title music --detach tmux-music";}
        {command = "${pkgs.kitty}/bin/kitty --title nixconf --detach tmux-nixconf";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store";}
        # Noctalia can manage connectivity; stop hardcoding bluetoothctl autoconnect.
        {command = "fcitx5 -d --replace";}
        {command = "fcitx5-remote -r";}
        {command = "${pkgs.openssh}/bin/ssh-add $HOME/.ssh/github_key";}
        {command = "swaymsg workspace 1 && ${pkgs.firefox}/bin/firefox";}
        {command = "${pkgs.safeeyes}/bin/safeeyes";}
        {command = "${pkgs.nicotine-plus}/bin/nicotine-plus";}
      ];
      workspaceAutoBackAndForth = true;

      ## Window Rules
      floating = {
        titlebar = false;
        border = 3;
        criteria = [
          {class = "nmtui";}
          {class = "Pavucontrol";}
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
          output = "${secondaryscreen}";
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
        "6" = [{class = "obsidian";}];
        "7" = [{app_id = "kitty"; title = "^music$";}];
        "8" = [{class = "zathura";}];
        "9" = [{app_id = "kitty"; title = "^nixconf$";}];
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
      bars = [];
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };
}
