# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  ...
}:
let
  fcitx5Addons = with pkgs; [
    fcitx5-gtk
    kdePackages.fcitx5-configtool
    fcitx5-mozc
    fcitx5-rime
    rime-data
  ];
in
{
  # Host-specific NixOS modules.
  imports = [
    ./hardware.nix # Host hardware scan
    ../../modules/nixos/common.nix # Shared system defaults
    ../../modules/nixos/apps/chromium.nix # Chromium/Chrome policies
    ../../modules/nixos/theme/stylix.nix # Stylix theme
    ../../modules/nixos/suites/gaming.nix # Gaming suite
    ../../modules/nixos/services/greetd.nix # Import greeter
    ../../modules/nixos/services/ollama.nix # Ollama daemon
    ../../modules/nixos/services/nicotine.nix # Nicotine+ + firewall
    ../../modules/nixos/thunar.nix # Thunar + GVFS/Tumbler helpers
    ../../modules/nixos/wm/sway.nix # Sway session (selectable in greetd)
    ../../modules/nixos/wm/niri.nix # Niri session (selectable in greetd)
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

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

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = fcitx5Addons;
  };

  # Keep the Qt inputcontext plugin available for Qt apps (fcitx5-qt).
  environment.variables.QT_PLUGIN_PATH = lib.mkAfter [
    "${pkgs.qt6Packages.fcitx5-qt}/${pkgs.qt6.qtbase.qtPluginPrefix}"
  ];

  nix.settings = {
    trusted-users = [
      "root"
      "xllvr"
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable LD
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      uv
    ];
  };

  # Enable SSH
  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  # Avoid clashing SSH agents (gcr-ssh-agent vs OpenSSH ssh-agent).
  services.gnome.gcr-ssh-agent.enable = false;

  # Enable Mullvad
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Enable polkit
  security.polkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xllvr = {
    isNormalUser = true;
    description = "Xllvr";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    qbittorrent-enhanced
    eyedropper
    gimp3
    audacity
    picard
    file-roller
    noctalia-shell
    qt6Packages.fcitx5-qt
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_IM_MODULES = "wayland;fcitx";
    SDL_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    MOZ_ENABLE_WAYLAND = "1";
  };

  system.stateVersion = "26.05";
}
