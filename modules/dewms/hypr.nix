{ pkgs, lib, ... }:

let
    startupScript = pkgs.pkgs.writeShellScriptBin "Startup" ''
        ${pkgs.waybar}/bin/waybar &
        ${pkgs.openssh}/bin/ssh-add $HOME/.ssh/github_rsa
    '';
in
    {

    imports = [
        ../apps/os/waybar.nix
    ];

    waybar.enable = true;

    wayland.windowManager.hyprland = {

        enable = true;
        xwayland.enable = true;
        systemd.enable = true;

        plugins = with pkgs.hyprlandPlugins; [ hy3 ];

        settings = {

            # Setup variables
            "$mod" = "SUPER";
            "$term" = "kitty";
            "$browser" = "firefox";
            "$menu" = "fuzzel";
            "$filemanager" = "thunar";
            "$primaryscreen" = "DP-2";
            "$secondaryscreen" = "DP-3";
            "$scriptsdir" = "~/repos/scripts";

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
                "col.active_border" = lib.mkForce "rgba(ff7f50ee) rgba(9400d3ee) 60deg";
                "col.inactive_border" = lib.mkForce "rgba(ffffffee)";

                layout = "hy3";
            };

            # Decorations
            decoration = {
                rounding = 5;

                blur = {
                    new_optimizations = true;
                    size = 7;
                    passes = 3;
                };

                blurls = "waybar";

                shadow = {
                    enabled = true;
                    range = 4;
                    render_power = 3;
                    color = lib.mkForce "rgba(1a1a1aee)";
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
                "float, class:^(mako)$"
            ];
            windowrulev2 = [
                "workspace 1, class:^(vesktop)$"
                "workspace 2 silent, class:^(Firefox)$"
                "workspace 6 silent, class:^(obsidian)$"
                "workspace 7 silent, class:^(musikcube)$"
                "float, class:.*(blueman-manager).*"
                "float, class:floating"
            ];

            # Keybinds
            bind = [
                # System controls
                "$mod ALT, O, exec, systemctl poweroff"
                "$mod ALT, R, exec, systemctl reboot"
                "$mod ALT, S, exec, systemctl suspend"
                "$mod ALT, L, exec, hyprctl dispatch exit"
                # Window controls
                "$mod, C, hy3:killactive"
                "$mod, V, togglefloating"
                "$mod, F, fullscreen"
                "$mod, J, togglesplit"
                "ALT, TAB, cyclenext"
                ## Focus
                "$mod, $left, hy3:movefocus, l"
                "$mod, $right, hy3:movefocus, r"
                "$mod, $up, hy3:movefocus, u"
                "$mod, $down, hy3:movefocus, d"

                # Workspace controls
                ## Move workspace to different monitor
                "$mod CTRL, $left, movecurrentworkspacetomonitor, $primaryscreen"
                "$mod CTRL, left, movecurrentworkspacetomonitor, $primaryscreen"
                "$mod CTRL, $right, movecurrentworkspacetomonitor, $secondaryscreen"
                "$mod CTRL, right, movecurrentworkspacetomonitor, $secondaryscreen"

                # Applications
                "$mod, RETURN, exec, $term"
                "$mod ALT, F, exec, $filemanager"
                "$mod, B, exec, $browser"

                # Tools
                "ALT, SPACE, exec, fuzzel"
                "$mod ALT, V, exec, $scriptsdir/fuzzclip"
                "$mod SHIFT, S, exec, $scriptsdir/fuzzshot"
            ] ++ (
                    # Go to and Move to Workspaces
                    builtins.concatLists (builtins.genList(
                        x: let
                            ws = let
                                c = (x + 1) / 10;
                            in
                                builtins.toString (x + 1 - (c * 10));
                        in [
                            "$mod, ${ws}, workspace, ${toString (x+1)}"
                            "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x+1)}"
                        ]
                    ) 10)
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
                "vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime"
                "kitty --detach --class musikcube --session $scriptsdir/musikvis"
                "$term -e syncthing"
                "fcitx5 -d -r"
                "fcitx5-remote -r"
                "firefox"
                "obsidian"
                "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
                "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
                "${startupScript}/bin/Startup"
                "export SSH_AUTH_SOCK"
                "safeeyes"
                "bluetoothctl trust 28:D0:EA:94:0C:A9"
                "bluetoothctl power on"
                "bluetoothctl connect 28:D0:EA:94:0C:A9"
            ];
            exec = [
                "mako"
                "xrdb -load ~/.Xdefaults"
            ];

        };
        
        extraConfig = ''
        # HY3 Settings
        bind = $mod ALT, G, submap, h3
        submap = h3

        ## Make groups
        bind = , V, hy3:makegroup, v, ephemeral
        bind = , H, hy3:makegroup, h, ephemeral
        bind = , T, hy3:makegroup, tab, ephemeral

        # Change group setting
        bind = SHIFT, T, hy3:changegroup, toggletab
        bind = , E, hy3:setephemeral, true

        # Move window to group
        bind = , $left, hy3:movewindow, l
        bind = , $up, hy3:movewindow, u
        bind = , $down, hy3:movewindow, d
        bind = , $right, hy3:movewindow, r

        bind = , escape, submap, reset
        submap = reset

        bind = $mod, TAB, hy3:focustab, right
        bind = $mod SHIFT, TAB, hy3:focustab, left
        '';

    };

}
