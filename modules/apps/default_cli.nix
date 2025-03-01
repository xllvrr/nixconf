{ pkgs, ... }:

{
    # Always installed CLIs
    home.packages = with pkgs; [

        # System Tools
        fuzzel
        wl-clipboard
        evtest
        usbutils
        libnotify
        jq
        cliphist
        gh

        # Terminal
        lazygit
        nsxiv
        devenv
        direnv

        # Programming Languages
        gcc

    ];
}
