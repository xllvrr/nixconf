{...}: {
  imports = [
    ../apps/audio/mpv.nix
    ../apps/audio/rmpc.nix
    # ../apps/audio/spotify.nix

    ../services/mpd.nix
  ];
}
