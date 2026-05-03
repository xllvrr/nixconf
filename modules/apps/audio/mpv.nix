{
  pkgs,
  pkgsUnstable,
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
}
