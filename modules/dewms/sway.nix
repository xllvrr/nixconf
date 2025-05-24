{
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  scriptsdir = "/home/xllvr/repos/scripts";
  filemanager = "${pkgs.thunar}/bin/thunar";
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
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
          "${mod}+e" = "layout toggle split";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+g" = "split h";
          "${mod}+s" = "layout stacking";
          "${mod}+v" = "split v";
          "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "${mod}+Ctrl+q" = "exit";

          "${mod}+Alt+v" = "exec ${scriptsdir}/fuzzclip";
          "${mod}+Shift+s" = "exec ${scriptsdir}/fuzzshot";

          "${mod}+Alt+f" = "exec ${filemanager}";
          "${mod}+b" = "exec ${pkgs.firefox}/bin/firefox";
        }
      ];
      focus.followMouse = false;
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
      ];
      workspaceAutoBackAndForth = true;
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };

  services.kanshi = {
    enable = true;

    profiles = {
      home_office = {
        outputs = [
          {
            criteria = "DP-2";
            scale = 2.0;
            status = "enable";
            position = "0,0";
          }
          {
            criteria = "DP-3";
            scale = 2.0;
            status = "enable";
            position = "1920,0";
          }
        ];
      };
    };
  };
}
