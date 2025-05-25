{
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  scriptsdir = "/home/xllvr/repos/scripts";
  filemanager = "${pkgs.thunar}/bin/thunar";

  primaryscreen = "DP-2";
  secondaryscreen = "DP-3";

  # colors
  cl_high = "#e57373";
  cl_indi = "#d9d8d8";
  cl_text = "#ffffff";
  cl_back = "#009ddc";
  cl_urge = "#ee2e24";
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

          "${mod}+Alt+f" = "exec ${filemanager}";
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
      colors = {
        focused = {
          background = "${cl_high}";
          border = "${cl_high}";
          child_border = "${cl_high}";
          text = "${cl_text}";
          indicator = "${cl_indi}";
        };
        focusedInactive = {
          background = "${cl_back}";
          border = "${cl_back}";
          child_border = "${cl_back}";
          text = "${cl_text}";
          indicator = "${cl_back}";
        };
        unfocused = {
          background = "${cl_back}";
          border = "${cl_back}";
          child_border = "${cl_back}";
          text = "${cl_text}";
          indicator = "${cl_back}";
        };
        urgent = {
          background = "${cl_urge}";
          border = "${cl_urge}";
          child_border = "${cl_urge}";
          text = "${cl_text}";
          indicator = "${cl_urge}";
        };
      };
      gaps = {
        inner = 5;
        outer = 10;
      };
      window.border = 3;
      floating.border = 3;

      ## Bars
      bars = {
        position = "top";
        command = "${pkgs.waybar}/bin/waybar";
      };
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
