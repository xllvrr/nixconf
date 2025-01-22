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
            eval "$(fzf --zsh)"
            eval "$(zoxide init --cmd cd zsh)"
            eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${../../extraconfs/shell/omp.toml})"

            batman () {
                man $1 | col -bx | bat -l man -p
            }
        '';
    };

}
