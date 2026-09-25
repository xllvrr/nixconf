{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Clipboard picker.
  fuzzclip = pkgs.writeShellApplication {
    name = "fuzzclip";
    runtimeInputs = [
      pkgs.cliphist
      pkgs.fuzzel
      pkgs.wl-clipboard
    ];
    text = ''
      selection="$(cliphist list | fuzzel -d -p 'Clipboard history below:')" || exit 0
      [ -n "$selection" ] || exit 0

      printf '%s\n' "$selection" | cliphist decode | wl-copy
    '';
  };

  # Noctalia screenshot mode picker.
  noctalia-shot = pkgs.writeShellApplication {
    name = "noctalia-shot";
    runtimeInputs = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.fuzzel
      pkgs.jq
      pkgs.niri
    ];
    text = ''
      mode="$(printf "region\nwindow\nfullscreen\npick screen\nall screens" | fuzzel -d -p 'Screenshot mode')" || exit 0

      case "$mode" in
          "region") noctalia msg screenshot-region;;
          "window")
            window_id="$(niri msg -j pick-window | jq -r '.id // empty')" || exit 0
            [ -n "$window_id" ] || exit 0
            niri msg action screenshot-window --id "$window_id" --write-to-disk false
            ;;
          "fullscreen") noctalia msg screenshot-fullscreen;;
          "pick screen") noctalia msg screenshot-fullscreen pick;;
          "all screens") noctalia msg screenshot-fullscreen all;;
      esac
    '';
  };

  # Screenshot picker.
  # fuzzshot = pkgs.writeShellApplication {
  #   name = "fuzzshot";
  #   runtimeInputs = [
  #     pkgs.fuzzel
  #     pkgs.grim
  #     pkgs.slurp
  #     pkgs.wl-clipboard
  #     pkgs.coreutils
  #   ];
  #   text = ''
  #     screenshots_dir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
  #     mkdir -p "$screenshots_dir"
  #
  #     target="$(printf "copy area\ncopy window\ncopy screen\nsave area\nsave window\nsave screen" | fuzzel -d -p 'Screenshot target')"
  #     file="$screenshots_dir/$(date +%Y-%m-%d_%H-%M-%S).png"
  #
  #     case "$target" in
  #         "copy area") grim -g "$(slurp)" - | wl-copy;;
  #         "copy window") grim -g "$(slurp)" - | wl-copy;;
  #         "copy screen") grim -o "$(slurp -o | cut -d' ' -f1)" - | wl-copy;;
  #         "save area") grim -g "$(slurp)" "$file";;
  #         "save window") grim -g "$(slurp)" "$file";;
  #         "save screen") grim -o "$(slurp -o | cut -d' ' -f1)" "$file";;
  #     esac
  #   '';
  # };
  #
  # # WiFi picker (nmcli + fuzzel).
  # fuzzwifi = pkgs.writeShellApplication {
  #   name = "fuzzwifi";
  #   runtimeInputs = [
  #     pkgs.networkmanager
  #     pkgs.fuzzel
  #     pkgs.libnotify
  #   ];
  #   text = ''
  #     # Get list of available networks
  #     networks=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | grep -v '^:' | sort -t: -k2 -nr | awk -F: '{
  #       lock = ($3 != "") ? "󰌾" : "󰌿";
  #       printf "%s %s\n", $1, lock
  #     }')
  #
  #     # Show in fuzzel
  #     selected=$(echo "$networks" | fuzzel -d -p 'Select WiFi:')
  #
  #     # Extract SSID (everything before the lock icon)
  #     ssid=$(echo "$selected" | sed 's/ 󰌾$//' | sed 's/ 󰌿$//')
  #
  #     if [ -n "$ssid" ]; then
  #       # Try to connect (will prompt for password if needed via nmcli agent)
  #       if nmcli device wifi connect "$ssid"; then
  #         notify-send "WiFi" "Connected to $ssid"
  #       else
  #         # If connection fails, might need password - prompt via fuzzel
  #         pass=$(fuzzel -d -p "Password for $ssid:" --password)
  #         if nmcli device wifi connect "$ssid" password "$pass"; then
  #           notify-send "WiFi" "Connected to $ssid"
  #         else
  #           notify-send "WiFi" "Failed to connect to $ssid"
  #         fi
  #       fi
  #     fi
  #   '';
  # };

  # Audio recorder managed by a user service so only its own pipeline is stopped.
  record-audio-worker = pkgs.writeShellApplication {
    name = "record-audio-worker";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.lame
      pkgs.pipewire
      pkgs.xdg-user-dirs
    ];
    text = ''
      state_dir="''${XDG_RUNTIME_DIR:?}/record-audio"
      mkdir -p "$state_dir"

      filename="$(xdg-user-dir DOWNLOAD)/out_$(date +%Y-%m-%d_%H-%M-%S).mp3"
      printf '%s\n' "$filename" > "$state_dir/output"

      pw-record -a -P '{ stream.capture.sink=true }' - \
        | lame -r -s 48 -m s -V7 - "$filename"
    '';
  };

  # Toggle the audio recorder service and copy the completed file URI on stop.
  record-audio = pkgs.writeShellApplication {
    name = "record-audio";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
      pkgs.wl-clipboard
    ];
    text = ''
      state_dir="''${XDG_RUNTIME_DIR:?}/record-audio"

      if systemctl --user is-active --quiet record-audio.service; then
        systemctl --user stop record-audio.service

        if [ -s "$state_dir/output" ]; then
          filename="$(< "$state_dir/output")"
          [ -f "$filename" ] && wl-copy -t text/uri-list <<< "file://''${filename}"
        fi
      else
        systemctl --user start record-audio.service
      fi
    '';
  };

  # Tmux sessions.
  tmux-music = pkgs.writeShellApplication {
    name = "tmux-music";
    runtimeInputs = [
      pkgs.tmux
      pkgs.rmpc
    ];
    text = ''
      tmux has-session -t music 2>/dev/null ||
          tmux new-session -d -s music -n "rmpc" "rmpc";
      tmux attach -t music
    '';
  };

  tmux-nixconf = pkgs.writeShellApplication {
    name = "tmux-nixconf";
    runtimeInputs = [ pkgs.tmux ];
    text = ''
      tmux has-session -t nixconf 2>/dev/null || \
        tmux new-session -d -s nixconf -c "$HOME/nixconf"
      tmux attach -t nixconf
    '';
  };
in
{
  home.packages = [
    fuzzclip
    noctalia-shot
    # fuzzshot
    # fuzzwifi
    record-audio
    tmux-music
    tmux-nixconf
  ];

  systemd.user.services.record-audio = {
    Unit.Description = "Record desktop audio";
    Service = {
      Type = "simple";
      ExecStart = lib.getExe record-audio-worker;
      KillSignal = "SIGINT";
      TimeoutStopSec = 5;
    };
  };
}
