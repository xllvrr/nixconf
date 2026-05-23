{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs
    mcp-nixos
    docker
  ];

  programs.codex = {
    enable = true;

    settings = {
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
