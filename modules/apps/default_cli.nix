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

        # Terminal
        lazygit
        nsxiv
        dragon

        # Programming Languages
        gcc
        R

    ];
}
