{pkgs, ...}: {
  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = builtins.readFile ../../extraconfs/shell/zshcompletion;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.ignoreAllDups = true;
    zplug = {
      enable = true;
      plugins = [
        {name = "jeffreytse/zsh-vi-mode";}
        {name = "Aloxaf/fzf-tab";}
      ];
    };
    initContent = ''
      # Setup fzf and ohmyposh
      eval "$(fzf --zsh)"

      # For colored man pages
      batman () {
          man $1 | col -bx | bat -l man -p
      }

      # Trying out centering
      precmd_center() {
        local CENTER=$(( LINES / 2))
        # print as many lines necessary so that content moves upward past half-screen
        printf '%.0s\n' {1..$(( LINES - CENTER ))}
        # move the cursor upward as many lines where printed to put it back where it was
        tput cuu $(( LINES - CENTER ))
      }
      add-zsh-hook precmd precmd_center

    '';
  };
}
