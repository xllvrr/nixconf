{pkgs, ...}: {
  # Always installed CLIs
  home.packages = with pkgs; [
    # System Tools
    grim
    slurp

    # Terminal
    lazygit
    feh
    devenv

    # Programming Languages
    gcc
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
