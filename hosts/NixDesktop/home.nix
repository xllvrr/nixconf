{
  config,
  pkgs,
  lib,
  ...
}:
{
  # =============================================================================
  # IMPORTS
  # =============================================================================
  imports = [
    ../../modules/home/wm/sway.nix
    ../../modules/home/wm/niri.nix
    ../../modules/home/apps/os/waybar.nix
    ../../modules/home/apps/os/noctalia.nix
    ../../modules/home/apps/browser/chromium.nix
    ../../modules/home/apps/office/onlyoffice.nix
    ../../modules/home/apps/terminal/kitty.nix
    ../../modules/home/apps/programming/vscode.nix
    ../../modules/home/scripts.nix
    ../../modules/home/suites/defaults.nix
    ../../modules/home/suites/ai.nix
    ../../modules/home/suites/audio.nix
  ];

  # =============================================================================
  # FEATURE FLAGS
  # =============================================================================
  waybar.enable = false;

  # =============================================================================
  # HOME MANAGER
  # =============================================================================
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

  home.stateVersion = "26.05"; # Please read the comment before changing.

  # =============================================================================
  # PACKAGES
  # =============================================================================
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

  # =============================================================================
  # SESSION / ENV
  # =============================================================================
  # Home Manager can export variables for the session so that it's agnostic
  # from the shell chosen
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    FLAKE = "/home/xllvr/nixos";
    NNN_FIFO = "/tmp/nnn.fifo";
  };

  # =============================================================================
  # SHELL
  # =============================================================================
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

  # =============================================================================
  # XDG DIRECTORIES
  # =============================================================================
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

  # =============================================================================
  # MISC
  # =============================================================================
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
