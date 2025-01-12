{ config, pkgs, inputs, ... }:

{

  imports = 
    [
      ../../modules/programs/firefox.nix
      ../../modules/dewms/hypr.nix
    ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "xllvr";
  home.homeDirectory = "/home/xllvr";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
  };

  # Manage XDG Directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "/run/media/xllvr/Storage/Downloads";
      documents = "/run/media/xllvr/Storage/Documents";
      music = "/run/media/xllvr/Media/Music";
      videos = "/run/media/xllvr/Media/Movies";
      pictures = "/run/media/xllvr/Media/Pictures";
    };
  };

  # Oh My Posh
  programs.oh-my-posh.enable = true;

  # Nix Helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since=5d --keep 5";
    flake = "/home/xllvr/nixos";
  };

  # Git Settings
  programs.git = {
    enable = true;
    userName = "xllvrr";
    userEmail = "dan@dtsa.email";
    aliases = {
      cm = "commit -am";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
