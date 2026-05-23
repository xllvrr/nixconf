{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs
    mcp-nixos
    docker
  ];

  programs.codex = {
    enable = true;

    settings = {
      # Keep Codex config declarative; HM writes this to ~/.codex/config.toml.
      model = "gpt-5.2";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";

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
