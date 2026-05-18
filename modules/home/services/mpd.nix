{...}: {
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/media/Music";
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
}

