{pkgs, ...}: {
  # Fish
  programs.fish = {
    enable = true;
    preferAbbrs = true;
    functions = {
      batman = "man $argv | col -bx | bat -l man -p";
      y = ''
                   set tmp (mktemp -t "yazi-cwd.XXXXXX")
                yazi $argv --cwd-file="$tmp"
                if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        	builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
    shellAbbrs = {
      n = "nnn";
      lg = "lazygit";
      cd = "z";
      bt = "but-cli";
    };
    shellInit = "${pkgs.openssh}/bin/ssh-add ~/.ssh/github_key";
    interactiveShellInit = ''
      # Set Vi Mode
      set -g fish_key_bindings fish_vi_key_bindings
    '';
  };
}
