{ ... }:
{
  # Fish
  programs.fish = {
    enable = true;
    preferAbbrs = true;
    functions = {
      batman = "man $argv | col -bx | bat -l man -p";
    };
    shellAbbrs = {
      lg = "lazygit";
      cd = "z";
      bt = "but-cli";
    };
    interactiveShellInit = ''
      # Set Vi Mode
      set -g fish_key_bindings fish_vi_key_bindings
    '';
  };
}
