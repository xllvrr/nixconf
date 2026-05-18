# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: let
  config-root = inputs.self.outPath;
  nixos-modules = config-root + "/modules/nixos";
in {
  imports = [
    ./hardware.nix # Import hardware for host
    (nixos-modules + "/common.nix") # Shared system defaults
    (nixos-modules + "/theme/stylix.nix") # Import stylix
    (nixos-modules + "/suites/gaming.nix") # Import gaming suite
    (nixos-modules + "/services/greetd.nix") # Import greeter
    (nixos-modules + "/services/ollama.nix") # Ollama daemon
    (nixos-modules + "/services/nicotine.nix") # Nicotine+ + firewall
    (nixos-modules + "/wm/sway.nix") # Sway session (selectable in greetd)
    (nixos-modules + "/wm/niri.nix") # Niri session (selectable in greetd)
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

  ## Software ##
  # Enable cache and trusted users
  nix.settings = {
    trusted-users = ["root" "xllvr"];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

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
  # Avoid clashing SSH agents (gcr-ssh-agent vs OpenSSH ssh-agent).
  services.gnome.gcr-ssh-agent.enable = false;

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

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;

  ## Packages ##

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    qbittorrent-enhanced
    libreoffice-fresh
    eyedropper
    gimp3
    audacity
    picard
    file-roller
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # System version
  system.stateVersion = "24.11";
}
