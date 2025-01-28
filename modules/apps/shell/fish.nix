{ pkgs, ... }:

{

    # Fish
    programs.fish = {
        enable = true;
        preferAbbrs = true;
        functions = {
            batman = "man $1 | col -bx | bat -l man -p";
        };
        shellInit = "${pkgs.openssh}/bin/ssh-add ~/.ssh/github_rsa";
    };

}
