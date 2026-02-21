{
  config,
  pkgs,
  pkgsUnstable,
  inputs,
  lib,
  ...
}: {
  # mpv settings
  programs.mpv = {
    enable = true;
    config = {
      gpu-api = "vulkan";
    };
    scripts = with pkgs.mpvScripts; [
      evafast
    ];
  };

  # mpd settings
  services.mpd = {
    enable = true;
    musicDirectory = "/run/media/xllvr/Media/Music";
    extraConfig = ''
      audio_output {
      type "pipewire"
      name "Pipewire MPD"
      mixer_type "software"
      }
      audio_output {
      type   "fifo"
      name   "FIFO MPD"
      path   "/tmp/mpd.fifo"
      format "44100:16:2"
      }
    '';
  };

  # cava
  programs.cava = {
    enable = true;
  };

  # rmpc
  programs.rmpc = {
    enable = true;
    package = pkgsUnstable.rmpc; # you already set this
    config = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]

      (
        address: "127.0.0.1:6600",
        password: None,
        theme: None,
        cache_dir: None,
        on_song_change: None,
        volume_step: 5,
        max_fps: 30,
        scrolloff: 0,
        wrap_navigation: false,
        enable_mouse: true,
        enable_config_hot_reload: true,
        status_update_interval_ms: 1000,
        select_current_song_on_change: true,
        center_current_song_on_change: true,
        browser_song_sort: [Disc, Track, Artist, Title],

        // Cava input via MPD FIFO (matches your mpd.conf)
        cava: (
          framerate: 60,
          autosens: true,
          sensitivity: 100,
          lower_cutoff_freq: 50,
          higher_cutoff_freq: 10000,
          input: (
            method: Fifo,
            source: "/tmp/mpd.fifo",
            sample_rate: 44100,
            channels: 2,
            sample_bits: 16,
          ),
          smoothing: (monstercat: true),
        ),

        tabs: [
          // ====== Queue tab: album art top-left, cava full-width bottom, with borders ======
          (
            name: "Queue",
            pane: Split(
              direction: Vertical,
              panes: [
                (
                  size: "60%",               // top area
                  borders: "BOTTOM",         // divider between top and bottom
                  pane: Split(
                    direction: Horizontal,
                    panes: [
                      (size: "30%", borders: "RIGHT", pane: Pane(AlbumArt)), // vertical divider to queue
                      (size: "70%", pane: Pane(Queue)),
                    ],
                  ),
                ),
                (
                  size: "40%",               // bottom area
                  pane: Pane(Cava),          // full-width Cava
                ),
              ],
            ),
          ),

          (name: "Directories",   pane: Pane(Directories)),
          (name: "Artists",       pane: Pane(Artists)),
          (name: "Album Artists", pane: Pane(AlbumArtists)),
          (name: "Albums",        pane: Pane(Albums)),
          (name: "Playlists",     pane: Pane(Playlists)),
          (name: "Search",        pane: Pane(Search)),
        ],
      )
    '';
  };

  # Spotify
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "media@dtsa.email";
        device_name = "nix";
      };
    };
  };
  programs.spotify-player = {
    enable = true;
    settings = {
      copy_command = {
        command = "wl-copy";
      };
    };
  };
}
