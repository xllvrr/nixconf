{ pkgs, lib, config, ... }:

{
    imports = 
        [
            ./zsh.nix
            ./fish.nix
        ];

    # Zoxide
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };

    # Oh My Posh settings
    programs.oh-my-posh = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        settings = builtins.fromTOML ( 
            builtins.unsafeDiscardStringContext(
                builtins.readFile "${../../extraconfs/shell/omp.toml}"
            ) );
    };
}
