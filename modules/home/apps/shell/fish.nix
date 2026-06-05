{ pkgs, ... }:
{
  # Fish
  programs.fish = {
    enable = true;
    preferAbbrs = true;
    functions = {
      batman = "man $argv | col -bx | bat -l man -p";
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
