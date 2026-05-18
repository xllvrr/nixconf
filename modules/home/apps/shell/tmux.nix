{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    prefix = "C-a";
    sensibleOnTop = true;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.sidebar
      tmuxPlugins.tmux-fzf
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.jump
    ];
  };
}
