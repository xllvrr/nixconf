# Gaming Settings
{pkgs, ...}: {
  # Enable openGL for gaming
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable AMD drivers
  services.xserver.videoDrivers = ["amdgpu"];

  # Install steam
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
    gamescopeSession.enable = true;
  };

  # Install other gaming related packages
  environment.systemPackages = with pkgs; [
    # Gaming
    mangohud
    protonup-qt
    lutris
    bottles

    # Minecraft
    prismlauncher

    # Emulators
    melonDS
    mgba
  ];
}
