# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ../../modules/config/stylix.nix
      ../../modules/config/gaming.nix
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
    # East Asian Fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  ## Hardware ##

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  ## User Settings ##

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xllvr = {
    isNormalUser = true;
    description = "Xllvr";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Home manager setup
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "xllvr" = import ./home.nix; };
    backupFileExtension = "backup";
  };

  # Allow home manager to manage shell
  programs.zsh.enable = true;

  # Enable stylix
  stylix.enable = true;

  ## Packages ##

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [

    # Editors
    vim
    neovim

    # Download
    curl
    wget

    # Version Control
    git

    # Dotfiles
    stow

    # CLI Tools
    eza
    fzf
    ripgrep
    zoxide
    unzip
    tree
    wev
    lazygit

    # Terminal
    kitty
    usbutils

    # Programming Languages
    gcc
    R

    # Nix Tools
    home-manager
    nix-output-monitor
    nvd

    # Communications
    webcord

    # Productivity
    obsidian
    cliphist
    hyprshot
    syncthing

    # OS
    waybar
    fuzzel
    mako
    wl-clipboard
    evtest

    # Security
    mullvad-vpn

    # Music
    lollypop
    tidal-hifi
    pulsemixer
    qpwgraph

  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    FLAKE = "/home/xllvr/nixos";
  };

  # System version
  system.stateVersion = "24.11";

}
