# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix # Import hardware for host
    ../default_configuration.nix # Import default configs
    ../../modules/config/system/stylix.nix # Import stylix
    ../../modules/config/system/gaming.nix # Import gaming module
    ../../modules/config/system/greetd.nix # Import greeter
  ];

  ## OS ##

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = ["amdgpu"];

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
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  ## Software ##

  # Enable cachix
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    trusted-users = ["root" "xllvr"];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Enable Sway
  programs.sway = {
    enable = true;
    xwayland.enable = true;
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
  programs.file-roller.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Enable LD
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      uv
    ];
  };

  ## Services ##

  # Enable SSH
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Enable Mullvad
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Enable polkit
  security.polkit.enable = true;

  ## User Settings ##

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xllvr = {
    isNormalUser = true;
    description = "Xllvr";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  # Home manager setup
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {"xllvr" = import ./home.nix;};
    backupFileExtension = "backup";
  };

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;

  ## Packages ##

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    qbittorrent-enhanced
    libreoffice-fresh
  ];

  # Hyprshot settings
  environment.variables = {
    HYPRSHOT_DIR = "/run/media/xllvr/Media/Pictures/Screenshots/";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # System version
  system.stateVersion = "24.11";
}
