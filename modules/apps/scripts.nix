{pkgs, ...}: let
  fuzzclip = pkgs.writeShellApplication {
    name = "fuzzclip";
    runtimeInputs = [pkgs.cliphist pkgs.fuzzel pkgs.wl-clipboard];
    text = ''
      cliphist list | fuzzel -d -p 'Clipboard history below:' | cliphist decode | wl-copy
    '';
  };

  fuzzshot = pkgs.writeShellApplication {
    name = "fuzzshot";
    runtimeInputs = [pkgs.fuzzel pkgs.hyprshot];
    text = ''
      case "$(printf "copy area\ncopy window\ncopy screen\nsave area\nsave window\nsave screen" | fuzzel -d -p 'Screenshot target')" in
          "copy area") hyprshot -m region --clipboard-only;;
          "copy window") hyprshot -m window --clipboard-only;;
          "copy screen") hyprshot -m output --clipboard-only;;
          "save area") hyprshot -m region;;
          "save window") hyprshot -m window;;
          "save screen") hyprshot -m output;;
      esac
    '';
  };

  record-audio = pkgs.writeShellApplication {
    name = "record-audio";
    runtimeInputs = [
      pkgs.pipewire
      pkgs.lame
      pkgs.xdg-user-dirs
      pkgs.wl-clipboard
      pkgs.procps # for pgrep/pkill
    ];
    text = ''
      if pgrep pw-record; then
        pkill pw-record
      else
        rand=$(tr -dc 'A-Z0-9' < /dev/urandom | fold -w 7 | head -n 1)
        filename="$(xdg-user-dir DOWNLOAD)/out_''${rand}.mp3"
        pw-record -a -P '{ stream.capture.sink=true }' - | lame -r -s 48 -m s -V7 - "$filename"
        wl-copy -t text/uri-list <<< "file://''${filename}"
      fi
    '';
  };

  tmux-music = pkgs.writeShellApplication {
    name = "tmux-music";
    runtimeInputs = [
      pkgs.tmux
      pkgs.rmpc
      pkgs.spotify-player
    ];
    text = ''
      tmux has-session -t music 2>/dev/null ||
          tmux new-session -d -s music -n "rmpc" "rmpc" \; \
              new-window -n "spotify" "spotify_player"
      tmux attach -t music
    '';
  };

  tmux-nixconf = pkgs.writeShellApplication {
    name = "tmux-nixconf";
    runtimeInputs = [pkgs.tmux];
    text = ''
      tmux has-session -t nixconf 2>/dev/null || \
        tmux new-session -d -s nixconf -c "$HOME/nixconf"
      tmux attach -t nixconf
    '';
  };

  fuzzwifi = pkgs.writeShellApplication {
    name = "fuzzwifi";
    runtimeInputs = [pkgs.networkmanager pkgs.fuzzel pkgs.libnotify];
    text = ''
      # Get list of available networks
      networks=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | grep -v '^:' | sort -t: -k2 -nr | awk -F: '{
        lock = ($3 != "") ? "󰌾" : "󰌿";
        printf "%s %s\n", $1, lock
      }')

      # Show in fuzzel
      selected=$(echo "$networks" | fuzzel -d -p 'Select WiFi:')

      # Extract SSID (everything before the lock icon)
      ssid=$(echo "$selected" | sed 's/ 󰌾$//' | sed 's/ 󰌿$//')

      if [ -n "$ssid" ]; then
        # Try to connect (will prompt for password if needed via nmcli agent)
        if nmcli device wifi connect "$ssid"; then
          notify-send "WiFi" "Connected to $ssid"
        else
          # If connection fails, might need password - prompt via fuzzel
          pass=$(fuzzel -d -p "Password for $ssid:" --password)
          if nmcli device wifi connect "$ssid" password "$pass"; then
            notify-send "WiFi" "Connected to $ssid"
          else
            notify-send "WiFi" "Failed to connect to $ssid"
          fi
        fi
      fi
    '';
  };
in {
  home.packages = [
    fuzzclip
    fuzzshot
    fuzzwifi
    record-audio
    tmux-music
    tmux-nixconf
  ];
}
