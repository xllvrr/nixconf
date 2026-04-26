{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../apps/os/waybar.nix
  ];

  waybar.enable = true;

  home.packages =
    [
      pkgs.river
      pkgs.wlr-randr
    ]
    ++ lib.optionals (pkgs ? rrwm) [pkgs.rrwm];

  xdg.configFile."river/init".text = ''
    #!/bin/sh

    mod="Super"
    primary="DP-1"
    secondary="HDMI-A-1"

    # Keyboard and launcher
    riverctl map normal Super Return spawn kitty
    riverctl map normal Super B spawn firefox
    riverctl map normal Alt Space spawn fuzzel
    riverctl map normal Super+Alt F spawn thunar
    riverctl map normal Super+Alt V spawn fuzzclip
    riverctl map normal Super+Shift S spawn fuzzshot
    riverctl map normal Super R spawn record-audio
    riverctl map normal Super+Shift Q close
    riverctl map normal Super+Shift E exit

    # Focus and move
    riverctl map normal Super H focus-view left
    riverctl map normal Super J focus-view down
    riverctl map normal Super K focus-view up
    riverctl map normal Super L focus-view right
    riverctl map normal Super+Shift H swap left
    riverctl map normal Super+Shift J swap down
    riverctl map normal Super+Shift K swap up
    riverctl map normal Super+Shift L swap right

    # Basic interaction defaults
    riverctl attach-mode bottom
    riverctl focus-follows-cursor normal
    riverctl set-cursor-warp on-focus-change

    # Tag mappings (1..9,0)
    for i in 1 2 3 4 5 6 7 8 9 0; do
      if [ "$i" -eq 0 ]; then
        tag=10
      else
        tag="$i"
      fi
      mask=$((1 << (tag - 1)))

      riverctl map normal "$mod" "$i" set-focused-tags "$mask"
      riverctl map normal "$mod+Shift" "$i" set-view-tags "$mask"
    done

    # Multimedia/system style bindings to mirror current sway habits
    riverctl map normal "$mod+Alt" O spawn systemctl poweroff
    riverctl map normal "$mod+Alt" R spawn systemctl reboot
    riverctl map normal "$mod+Alt" S spawn systemctl suspend

    # Monitor setup (matches current sway output layout where available)
    wlr-randr --output "$primary" --mode 1920x1080 --pos 0,0 || true
    wlr-randr --output "$secondary" --mode 1680x1050 --pos 1920,0 || true

    # River window aesthetics close to current sway values
    riverctl border-width 3

    # Start session components
    mako &
    waybar &
    syncthing &
    kitty --class music --detach tmux-music &
    kitty --class nixconf --detach tmux-nixconf &
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
    bluetoothctl trust 28:D0:EA:94:0C:A9 &
    bluetoothctl power on &
    bluetoothctl connect 28:D0:EA:94:0C:A9 &
    fcitx5 -d --replace &
    fcitx5-remote -r &
    ssh-add "$HOME/.ssh/github_key" &
    firefox &
    safeeyes &

    # Prefer rrwm if available (with gap flags when supported); otherwise
    # fall back to rivertile with explicit inner/outer gaps.
    if command -v rrwm >/dev/null 2>&1; then
      if rrwm --help 2>/dev/null | grep -q -- '--inner-gap'; then
        rrwm --inner-gap 5 --outer-gap 10 &
      else
        rrwm &
      fi
    elif command -v rivertile >/dev/null 2>&1; then
      rivertile -view-padding 5 -outer-padding 10 &
    fi
  '';

  xdg.configFile."river/init".executable = true;
}
