{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs
    mcp-nixos
    docker
  ];

  programs.codex = {
    enable = true;

    settings = {
      model = "gpt-5.5";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;

      mcp_servers = {
        context7 = {
          command = "npx";
          args = ["-y" "@upstash/context7-mcp"];
        };

        nixos = {
          command = "mcp-nixos";
        };
      };
    };
  };
}
