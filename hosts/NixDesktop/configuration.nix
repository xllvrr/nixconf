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
        ];

    ## OS ##

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "NixDesktop"; # Define your hostname.
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

    ## Software ##

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GDM
    services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
    };

    # Enable the Hyprland Window Manager
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Enable Thunar
    programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
            thunar-media-tags-plugin
        ];
    };
    programs.xfconf.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    ## Services ##

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

    # Enable SSH
    services.openssh.enable = true;
    programs.ssh.startAgent = true;

    # Enable Mullvad
    services.mullvad-vpn.enable = true;


    ## User Settings ##

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.xllvr = {
        isNormalUser = true;
        description = "Xllvr";
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.fish;
    };

    # Home manager setup
    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = { "xllvr" = import ./home.nix; };
        backupFileExtension = "backup";
    };

    # Shell
    programs.zsh.enable = true;
    programs.fish.enable = true;

    ## Packages ##

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Host-specific packages
    environment.systemPackages = with pkgs; [
    ];

    # Hyprshot settings
    environment.variables = {
        HYPRSHOT_DIR = "/run/media/xllvr/Media/Pictures/Screenshots/";
    };

    environment.sessionVariables = {
    };

    # System version
    system.stateVersion = "24.11";

}
