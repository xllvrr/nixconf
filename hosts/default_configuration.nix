{ pkgs, ... }:

{
    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
        htop

        # Terminal
        kitty

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

        # Security
        mullvad-vpn

    ];


}
