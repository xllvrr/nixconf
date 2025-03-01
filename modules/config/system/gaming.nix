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

    # Install steam
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    # Install other gaming related packages
    environment.systemPackages = with pkgs; [

        # Gaming
        mangohud
        protonup-qt
        lutris
        bottles

        # Minecraft
        prismlauncher

        # Communications
        vesktop

    ];

}
