{pkgs, ...}: {
  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
  };
}
