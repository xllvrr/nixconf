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
  wayland.windowManager.sway = {
    enable = true;
    config = {
      ## Keybinds
      modifier = mod;
      keybindings = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (map (num: let
          ws = toString num;
        in {
          "${mod}+${ws}" = "workspace ${ws}";
          "${mod}+Ctrl+${ws}" = "move container to workspace ${ws}";
        }) [1 2 3 4 5 6 7 8 9 0]))

        (lib.attrsets.concatMapAttrs (key: direction: {
            "${mod}+${key}" = "focus ${direction}";
            "${mod}+Ctrl+${key}" = "move ${direction}";
          }) {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          })

        {
          "${mod}+Return" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty";
          "${mod}+space" = "exec --no-startup-id fuzzel";

          "${mod}+shift+q" = "kill";

          "${mod}+a" = "focus parent";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+x" = "floating toggle";
          "${mod}+g" = "split h";
          "${mod}+v" = "split v";
          "${mod}+e" = "layout toggle split";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "${mod}+Ctrl+q" = "exit";

          "${mod}+Alt+v" = "exec ${scriptsdir}/fuzzclip";
          "${mod}+Shift+s" = "exec ${scriptsdir}/fuzzshot";

          "${mod}+Alt+f" = "exec thunar";
          "${mod}+b" = "exec ${pkgs.firefox}/bin/firefox";
        }
      ];
      focus.followMouse = false;

      ## Startup
      startup = [
        {
          command = "mako";
          always = true;
        }
        {
          command = "fcitx5 -d --replace";
          always = true;
        }
        {
          command = "fcitx5-remote -r";
          always = true;
        }
        {command = "vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";}
        {command = "syncthing";}
        {command = "kitty --detach class musikcube --session ${scriptsdir}/musikvis";}
        {command = "safeeyes";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store";}
        {command = "bluetoothctl trust 28:D0:EA:94:0C:A9";}
        {command = "bluetoothctl power on";}
        {command = "bluetoothctl connect 28:D0:EA:94:0C:A9";}
        {command = "${pkgs.openssh}/bin/ssh-add $HOME/.ssh/github_rsa";}
      ];
      workspaceAutoBackAndForth = true;

      ## Window Rules
      floating = {
        titlebar = false;
        criteria = [
          {class = "nmtui";}
          {class = "Pavucontrol";}
          {class = "^mako$";}
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
        "7" = [{class = "musikcube";}];
      };

      ## Aesthetics
      gaps = {
        inner = 5;
        outer = 10;
      };
      window.border = 3;
      floating.border = 3;

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
