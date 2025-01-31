{ pkgs, ... }:

{

    # Fish
    programs.fish = {
        enable = true;
        preferAbbrs = true;
        functions = {
            batman = "man $argv | col -bx | bat -l man -p";
        };
        shellInit = "${pkgs.openssh}/bin/ssh-add ~/.ssh/github_rsa";
        interactiveShellInit = ''
            # Set Vi Mode
            set -g fish_key_bindings fish_vi_key_bindings
        '';
    };

}
