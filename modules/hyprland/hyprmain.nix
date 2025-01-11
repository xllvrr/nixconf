{ pkgs, config, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "Startup" ''
    ${pkgs.waybar}/bin/waybar &
  '';
in
  {
  wayland.windowManager.hyprland = {

    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {

      # Setup variables
      "$mod" = "SUPER";
      "$term" = "kitty";
      "$browser" = "firefox";
      "$menu" = "fuzzel -b 282c34ff -s 000000 -S 74bb80ff -t 74bb80ff -C 74bba4ff";
      "$filemanager" = "nautilus";
      "$primaryscreen" = "DP-2";
      "$secondaryscreen" = "DP-3";

      # Vim directions
      "$left" = "h";
      "$down" = "j";
      "$up" = "k";
      "$right" = "l";

      # Monitors
      monitor = [
        "DP-2, 1920x1080@59.93, 0x0, 1"
        "DP-3, 1680x1050@60.00, 1920x0, 1"
      ];

      # Inputs
      input = {
        follow_mouse = 1;
        scroll_method = "on_button_down";
        scroll_button = 277;
      };

      # Borders
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 3;
        "col.active_border" = "rgba(ff7f50ee) rgba(9400d3ee) 60deg";
        "col.inactive_border" = "rgba(ffffffee)";
      };

      # Decorations
      decoration = {
        rounding = 5;

        blur = {
          new_optimizations = true;
          size = 7;
          passes = 3;
        };

        blurls = "lockscreen";

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle.preserve_split = true;
      master.new_status = "master";

      # Window Rules
      windowrule = [
        "pseudo, fcitx"
        "workspace 1, class:^(webcord)$"
        "workspace 2 silent, class:^(Firefox)$"
        "workspace 6 silent, class:^(obsidian)$"
        "workspace 7 silent, class:^(lollypop)$"
        "float, class:^(mako)$"
      ];

      # Keybinds
      bind = [
        # System controls
        "$mod, L, hyprctl dispatch exit"
        "$mod ALT, O, exec, systemctl poweroff"
        "$mod ALT, R, exec, systemctl reboot"
        "$mod ALT, S, exec, systemctl suspend"

        # Window controls
        "$mod, C, killactive"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, J, togglesplit"
        "ALT, TAB, cyclenext"
        ## Focus
        "mod, $left, movefocus, l"
        "mod, $right, movefocus, r"
        "mod, $up, movefocus, u"
        "mod, $down, movefocus, d"

        ## Move workspace to different monitor
        "mod CTRL, $left, movecurrentoworkspacetomonitor, $primaryscreen"
        "mod CTRL, left, movecurrentoworkspacetomonitor, $primaryscreen"
        "mod CTRL, $right, movecurrentoworkspacetomonitor, $secondaryscreen"
        "mod CTRL, right, movecurrentoworkspacetomonitor, $secondaryscreen"

        # Applications
        "$mod, RETURN, exec, $term"
        "$mod ALT, F, exec, $filemanager"
        "$mod, B, exec, $browser"

        # Tools
        "ALT, SPACE, exec, fuzzel"
        "$mod ALT, V, exec, ~/repos/scripts/fuzzclip"
      ]
        ++ (
          # Workspace movement
          builtins.concatLists (builtins.genList (i:
          let ws = i+1;
          in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ])) 
        );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Window binds
      workspace = [
        "1, monitor:$primaryscreen"
        "4, monitor:$primaryscreen"
        "2, monitor:$secondaryscreen"
        "6, monitor:$secondaryscreen"
      ];

      # Startup
      exec-once = [
        "webcord --enable-features=UseOzonePlatform --enable-wayland-ime"
        "lollypop"
        "$term -e syncthing"
        "fcitx5 -d -r"
        "fcitx5-remote -r"
        "firefox"
        "obsidian"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
        "${startupScript}/bin/Startup"
        "export SSH_AUTH_SOCK"
        "ssh-add ~/.ssh/github_rsa"
      ];
      exec = [
        "mako"
        "xrdb -load ~/.Xdefaults"
      ];

    };
  };

}
