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
    settings = {
      user = {
        name = "xllvrr";
        email = "dan@dtsa.email";
      };
      aliases = {
        cm = "commit -am";
      };
      init.defaultBranch = "main";
    };
  };
  programs.delta.enable = true;

  # SSH Settings
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        hostname = "dan@dtsa.email";
        identityFile = "/home/xllvr/.ssh/github_rsa";
        addKeysToAgent = "yes";
        forwardAgent = false;
        compression = false;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
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

  # Claude Code
  programs.claude-code = {
    enable = true;
  };
}
