{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  primaryOutput = "DP-1";
  secondaryOutput = "HDMI-A-1";

  wallpaper =
    if (config ? stylix && config.stylix ? image)
    then config.stylix.image
    else inputs.self.outPath + "/modules/nixos/theme/Wallpaper.png";

  waybarNiriConfig = "$XDG_CONFIG_HOME/waybar/config-niri";
  waybarStyle = "$XDG_CONFIG_HOME/waybar/style.css";
in {
  xdg.configFile."niri/config.kdl".text = ''
    input {
        focus-follows-mouse

        mouse {
            scroll-method "on-button-down"
            scroll-button 277
            scroll-button-lock
        }
    }

    output "${primaryOutput}" {
        mode "1920x1080"
        position x=0 y=0
    }

    output "${secondaryOutput}" {
        mode "1680x1050"
        position x=1920 y=0
    }

    layout {
        gaps 5
    }

    spawn-sh-at-startup "${pkgs.swww}/bin/swww-daemon"
    spawn-sh-at-startup "${pkgs.swww}/bin/swww img ${lib.escapeShellArg (toString wallpaper)} --transition-type none"
    spawn-sh-at-startup "${pkgs.waybar}/bin/waybar -c ${waybarNiriConfig} -s ${waybarStyle}"

    spawn-at-startup "mako"
    spawn-at-startup "syncthing"
    spawn-sh-at-startup "${pkgs.kitty}/bin/kitty --class music --detach tmux-music"
    spawn-sh-at-startup "${pkgs.kitty}/bin/kitty --class nixconf --detach tmux-nixconf"
    spawn-sh-at-startup "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
    spawn-sh-at-startup "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
    spawn-sh-at-startup "bluetoothctl trust 28:D0:EA:94:0C:A9"
    spawn-sh-at-startup "bluetoothctl power on"
    spawn-sh-at-startup "bluetoothctl connect 28:D0:EA:94:0C:A9"
    spawn-sh-at-startup "fcitx5 -d --replace"
    spawn-sh-at-startup "fcitx5-remote -r"
    spawn-sh-at-startup "${pkgs.openssh}/bin/ssh-add $HOME/.ssh/github_key"
    spawn-sh-at-startup "${pkgs.safeeyes}/bin/safeeyes"
    spawn-sh-at-startup "${pkgs.nicotine-plus}/bin/nicotine-plus"

    window-rule {
        match app-id=r#"(pavucontrol|blueman-manager)$"#
        open-floating true
    }

    binds {
        Super+Return { spawn "${pkgs.kitty}/bin/kitty"; }
        Alt+Space { spawn "fuzzel"; }

        Super+C repeat=false { close-window; }
        Super+F repeat=false { fullscreen-window; }
        Super+Z repeat=false { toggle-window-floating; }

        Super+H { focus-column-left; }
        Super+J { focus-window-down; }
        Super+K { focus-window-up; }
        Super+L { focus-column-right; }

        Super+Ctrl+H { move-column-left; }
        Super+Ctrl+J { move-window-down; }
        Super+Ctrl+K { move-window-up; }
        Super+Ctrl+L { move-column-right; }

        Super+Shift+H { move-workspace-to-monitor-left; }
        Super+Shift+J { move-workspace-to-monitor-down; }
        Super+Shift+K { move-workspace-to-monitor-up; }
        Super+Shift+L { move-workspace-to-monitor-right; }

        Super+1 { focus-workspace 1; }
        Super+2 { focus-workspace 2; }
        Super+3 { focus-workspace 3; }
        Super+4 { focus-workspace 4; }
        Super+5 { focus-workspace 5; }
        Super+6 { focus-workspace 6; }
        Super+7 { focus-workspace 7; }
        Super+8 { focus-workspace 8; }
        Super+9 { focus-workspace 9; }
        Super+0 { focus-workspace 10; }

        Super+Shift+1 { move-window-to-workspace 1; }
        Super+Shift+2 { move-window-to-workspace 2; }
        Super+Shift+3 { move-window-to-workspace 3; }
        Super+Shift+4 { move-window-to-workspace 4; }
        Super+Shift+5 { move-window-to-workspace 5; }
        Super+Shift+6 { move-window-to-workspace 6; }
        Super+Shift+7 { move-window-to-workspace 7; }
        Super+Shift+8 { move-window-to-workspace 8; }
        Super+Shift+9 { move-window-to-workspace 9; }
        Super+Shift+0 { move-window-to-workspace 10; }

        Super+M { move-window-to-floating; }
        Super+Shift+M { focus-floating; }

        Super+Shift+R { spawn-sh "niri msg action load-config-file"; }
        Super+Ctrl+Q repeat=false { quit; }

        Super+Alt+V { spawn "fuzzclip"; }
        Super+Shift+S { spawn "fuzzshot"; }

        Super+Alt+F { spawn "thunar"; }
        Super+B { spawn "${pkgs.firefox}/bin/firefox"; }
        Super+E { spawn "${pkgs.kitty}/bin/kitty" "--detach" "yazi"; }
        Super+R { spawn "record-audio"; }
    }
  '';
}
