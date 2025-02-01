{ pkgs, lib, config, ... }:

{
    imports = 
        [
            ./zsh.nix
            ./fish.nix
            ./nnn.nix
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

    # Git Settings
    programs.git = {
        enable = true;
        userName = "xllvrr";
        userEmail = "dan@dtsa.email";
        aliases = {
            cm = "commit -am";
        };
    };

    # SSH Settings
    programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks = {
            github = {
                hostname = "dan@dtsa.email";
                identityFile = "/home/xllvr/.ssh/github_rsa";
            };
        };
    };

}
