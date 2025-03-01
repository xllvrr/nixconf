{ pkgs, ... }:

{
    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Enable documentation
    documentation = {
        enable = true;
        man = {
            enable = true;
            man-db.enable = false;
            mandoc.enable = true;
            generateCaches = true;
        };
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Fonts
    fonts.packages = with pkgs; [
        jetbrains-mono
        dejavu_fonts
        nerd-fonts.symbols-only
        # East Asian Fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
    ];

    # Redshift
    services.redshift = {
        enable = true;
        temperature = {
            day = 5500;
            night = 3700;
        };
    };
    services.geoclue2.enable = true;
    location.provider = "geoclue2";

    # Always installed packages
    environment.systemPackages = with pkgs; [

        # Editors
        vim
        neovim

        # Download
        curl
        wget

        # Version Control
        git
        stow
        openssh

        # Terminal
        kitty
        eza
        fzf
        ripgrep
        unzip
        tree
        wev
        lazygit
        htop

        # Documentation
        linux-manual
        man-pages
        man-pages-posix
        bat

        # Programming Languages
        gcc
        R

        # Nix Tools
        home-manager
        nix-output-monitor
        nvd

        # System Tools
        fuzzel
        wl-clipboard
        evtest
        usbutils
        libnotify
        jq
        cliphist
        gzip

    ];


}
