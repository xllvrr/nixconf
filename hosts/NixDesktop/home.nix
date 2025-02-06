{ config, pkgs, inputs, lib, ... }:

{

    imports = 
        [
            ../../modules/dewms/hypr.nix
            ../../modules/apps/default_gui.nix # Import default guis
            ../../modules/apps/default_cli.nix # Import default clis
            ../../modules/apps/browser/firefox.nix
            ../../modules/apps/terminal/kitty.nix
            ../../modules/apps/shell/shell.nix
        ];

    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "xllvr";
    home.homeDirectory = "/home/xllvr";
    home.sessionPath = [
        "$HOME/.local/bin" 
        "$HOME/.config/nvim"
        "$HOME/.config/lsp"
        "$HOME/repos/scripts"
        "/usr/share/pkgconfig"
    ];

    home.stateVersion = "24.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [

        # Screenshots
        grim
        slurp
        hyprshot

        # Communications
        vesktop

    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
    };

    # Home Manager can export variables for the session so that it's agnostic
    # from the shell chosen
    home.sessionVariables = {
        EDITOR="nvim";
        TERMINAL="kitty";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
        FLAKE = "/home/xllvr/nixos";
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        SDL_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
    };

    # In the same vein, home.shellAliases allows defining shell-agnostic aliases
    home.shellAliases = {
        # Applications
        v = "nvim";
        ex = "eza -a";
        waybar = "pkill waybar;waybar &!";
        # System Tools
        grep = "grep --color";
        cp = "cp -i";
        df = "df -h";
    };

    # Enable stylix
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.targets.qt.platform = "qtct";

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

    # Disable home manager defaulting to man-db
    programs.man.enable = false;

    # Nix Helper
    programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since=5d --keep 5";
        flake = "/home/xllvr/nixos";
    };

    # Mako settings
    services.mako = {
        enable = true;
        actions = true;
        anchor = "top-right";
        borderRadius = 8;
        borderSize = 1;
        icons = true;
        layer = "overlay";
        maxVisible = 3;
        padding = "10";
        width = 300;
    };

    # Cava settings
    programs.cava.settings = {
        general.autosens = 1;
        input.method = "pipewire";
        output.method = "noncurses";
        smoothing.monstercat = 1;
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
