{...}: {
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (
      builtins.unsafeDiscardStringContext (
        builtins.readFile ../../../../configs/omp/omp.toml
      )
    );
  };
}
