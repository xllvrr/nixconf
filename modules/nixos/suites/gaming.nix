# Gaming Settings
{ pkgs, ... }:
{
  # Enable openGL for gaming
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable AMD drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Use physical button positions instead of Nintendo-style labels for SDL controllers.
  environment.sessionVariables.SDL_GAMECONTROLLER_USE_BUTTON_LABELS = "0";

  # Install steam
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  # Install other gaming related packages
  environment.systemPackages = with pkgs; [
    # Gaming
    mangohud
    protonup-qt
    lutris
    bottles
    r2modman

    # Minecraft
    prismlauncher

    # Emulators
    melonds
    mgba
  ];
}
