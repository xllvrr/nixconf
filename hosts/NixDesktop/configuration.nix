# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
    imports =
        [ 
            ./hardware.nix # Import hardware for host
            ../default_configuration.nix # Import default configs
            ../../modules/config/stylix.nix # Import stylix
            ../../modules/config/gaming.nix # Import gaming module
            ../../modules/apps/default_gui.nix # Import default guis
        ];

    ## OS ##

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "NixDesktop"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Asia/Singapore";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_SG.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_SG.UTF-8";
        LC_IDENTIFICATION = "en_SG.UTF-8";
        LC_MEASUREMENT = "en_SG.UTF-8";
        LC_MONETARY = "en_SG.UTF-8";
        LC_NAME = "en_SG.UTF-8";
        LC_NUMERIC = "en_SG.UTF-8";
        LC_PAPER = "en_SG.UTF-8";
        LC_TELEPHONE = "en_SG.UTF-8";
        LC_TIME = "en_SG.UTF-8";
    };

    # Languages (Fcitx)
    i18n.inputMethod = {
        type = "fcitx5";
        enable = true;
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
            fcitx5-gtk
            fcitx5-mozc
            fcitx5-rime
            rime-data
        ];
    };

    # Align nix path
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # System timers
    systemd = {
        timers.sleep_timer = {
            description = "Sleep Timer";
            wantedBy = [ "timers.target" ];
            partOf = [ "sleeptimer.service" ];
            timerConfig = {
                OnCalendar = "Sun..Thur 23:00";
                Unit = "sleep_timer.service";
            };
        };
        user.services.sleep_timer = {
            description = "Suspend PC for Sleep";
            serviceConfig.Type = "simple";
            script = ''
                ${pkgs.systemd}/bin/systemctl suspend
            '';
        };
    };

    ## Software ##

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Enable the Hyprland Window Manager
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    ## Hardware ##

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        extraConfig.pipewire.adjust-sample-rate = {
            "context.properties" = {
                "default.clock.allowed-rates" = [ 32000 44100 48000 88200 96000 192000 ];
            };
        };
    };


    ## User Settings ##

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.xllvr = {
        isNormalUser = true;
        description = "Xllvr";
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
    };

    # Home manager setup
    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = { "xllvr" = import ./home.nix; };
        backupFileExtension = "backup";
    };

    # Shell
    programs.zsh.enable = true;

    ## Packages ##

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Host-specific packages
    environment.systemPackages = with pkgs; [

        # Screenshots
        grim
        slurp
        hyprshot

        # Communications
        vesktop

        # Productivity
        obsidian
        syncthing

    ];

    # Hyprshot settings
    environment.variables = {
        HYPRSHOT_DIR = "/run/media/xllvr/Media/Pictures/Screenshots/";
    };

    environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
        FLAKE = "/home/xllvr/nixos";
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        SDL_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
    };

    # System version
    system.stateVersion = "24.11";

}
