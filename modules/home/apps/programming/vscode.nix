{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # language agnostic
      vscodevim.vim
      mhutchie.git-graph
      eamodio.gitlens
      github.copilot
      esbenp.prettier-vscode
      usernamehw.errorlens
      johnpapa.vscode-peacock
      dendron.dendron-paste-image
      christian-kohler.path-intellisense
      gruntfuggly.todo-tree
      vscode-icons-team.vscode-icons
      mkhl.direnv

      # r
      reditorsupport.r
      ms-vscode.cpptools

      # python
      ms-python.python
      tamasfe.even-better-toml
      ms-toolsai.jupyter
      charliermarsh.ruff

      # latex
      james-yu.latex-workshop
    ];
  };
}
