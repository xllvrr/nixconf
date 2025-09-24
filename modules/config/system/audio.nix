{
  config,
  pkgs,
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
    '';
  };

  # rmpc
  programs.rmpc = {
    enable = true;
  };
}
