{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./fish.nix
  ];

  # Yazi
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      show_hidden = true;
    };
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  # Oh My Posh settings
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (
      builtins.unsafeDiscardStringContext (
        builtins.readFile "${../../extraconfs/shell/omp.toml}"
      )
    );
  };

  # Git Settings
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "xllvrr";
    userEmail = "dan@dtsa.email";
    aliases = {
      cm = "commit -am";
    };
    extraConfig = {
      init.defaultBranch = "main";
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

  # Tmux Settings
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    sensibleOnTop = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.sidebar
      tmuxPlugins.tmux-fzf
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.jump
    ];
  };

  # Additional packages
  home.packages = [pkgs.claude-code];
}
