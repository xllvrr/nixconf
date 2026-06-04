{
  pkgs,
  inputs,
  ...
}:
{
  # =============================================================================
  # NIX
  # =============================================================================
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Prefer flake registry over legacy NIX_PATH
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
  };

  # =============================================================================
  # LOCALE / INPUT
  # =============================================================================
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # =============================================================================
  # DOCUMENTATION
  # =============================================================================
  # Enable documentation
  documentation = {
    enable = true;
    man = {
      enable = true;
      man-db.enable = false;
      mandoc.enable = true;
      cache.enable = true;
    };
  };

  # =============================================================================
  # SERVICES
  # =============================================================================
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # =============================================================================
  # FONTS
  # =============================================================================
  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    dejavu_fonts
    nerd-fonts.symbols-only
    # East Asian Fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  # =============================================================================
  # LOCATION / NIGHT LIGHT
  # =============================================================================
  # Redshift (sunsetted; Noctalia provides night light)
  services.redshift.enable = false;
  services.geoclue2.enable = true;
  location.provider = "geoclue2";

  # =============================================================================
  # BASE PACKAGES
  # =============================================================================
  # Always installed packages
  environment.systemPackages = with pkgs; [
    # Editors
    neovim

    # Download
    curl
    wget

    # Version Control
    git
    git-filter-repo
    lazygit
    openssh

    # Terminal
    eza
    fzf
    ripgrep
    fd
    unzip
    unrar-free
    tree
    wev
    btop

    # Documentation
    # linux-manual
    man-pages
    man-pages-posix
    bat

    # Programming Languages
    gcc
    R
    cargo

    # System Tools
    grim
    slurp

    # Nix Tools
    home-manager
    nixfmt
    nix-output-monitor
    nvd
    hydra-check

    # System Tools
    wl-clipboard
    evtest
    usbutils
    libnotify
    jq
    cliphist
    gzip
    caligula
    pastel
    feh

    # GUI
    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
  ];
}
