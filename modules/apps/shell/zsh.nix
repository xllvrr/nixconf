{ pkgs, ... }:

{

    # Zsh
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        completionInit = (builtins.readFile ../../extraconfs/shell/zshcompletion);
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        history.ignoreAllDups = true;
        zplug = {
            enable = true;
            plugins = [
                { name = "jeffreytse/zsh-vi-mode" ; }
                { name = "Aloxaf/fzf-tab" ; }
            ];
        };
        initExtra = ''
            # Setup fzf and ohmyposh
            eval "$(fzf --zsh)"
            eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${../../extraconfs/shell/omp.toml})"

            # For auto-adding github ssh key
            eval "$(${pkgs.openssh}/bin/ssh-add $HOME/.ssh/github_rsa)"

            # For colored man pages
            batman () {
                man $1 | col -bx | bat -l man -p
            }

            # For centering the screen
            PS1=$'\n\n\n\n\n\n\n\n\e[8A'"$PS1"

        '';
    };

    # Zoxide
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };

}
