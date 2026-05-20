{
  config,
  pkgs,
  repoRoot,
  lib,
  ...
}: let
  home-modules = repoRoot + "/modules/home";
in {
  imports = [
    (home-modules + "/wm/sway.nix")
    (home-modules + "/wm/niri.nix")
    (home-modules + "/apps/os/waybar.nix")
    (home-modules + "/scripts.nix")
    (home-modules + "/suites/defaults.nix") # Base/default apps + shell tooling
    (home-modules + "/apps/browser/firefox.nix")
    (home-modules + "/apps/terminal/kitty.nix")
    (home-modules + "/apps/programming/vscode.nix")
    (home-modules + "/suites/ai.nix")
    (home-modules + "/suites/audio.nix")
    (home-modules + "/services/mako.nix")
  ];

  waybar.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "xllvr";
  home.homeDirectory = "/home/xllvr";
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.config/nvim"
    "$HOME/.config/lsp"
    "/usr/share/pkgconfig"
  ];

  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # And allow for unfree packages within
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Screenshots
    grim
    slurp

    # Others
    zoom-us
    anki
    mpc
  ];

  # Home Manager can export variables for the session so that it's agnostic
  # from the shell chosen
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    FLAKE = "/home/xllvr/nixos";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    NNN_FIFO = "/tmp/nnn.fifo";
  };

  # In the same vein, home.shellAliases allows defining shell-agnostic aliases
  home.shellAliases = {
    # Applications
    v = "nvim";
    ex = "eza -a";
    # System Tools
    grep = "grep --color";
    cp = "cp -i";
    df = "df -h";
    cd = "z";
  };

  # Manage XDG Directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "/mnt/storage/Downloads";
      documents = "/mnt/storage/Documents";
      music = "/mnt/media/Music";
      videos = "/mnt/media/Movies";
      pictures = "/mnt/media/Pictures";
    };
  };

  # Disable home manager defaulting to man-db
  programs.man.enable = false;

  # Nix Helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 5d --keep 5";
    flake = "/home/xllvr/nixconf";
  };
}
