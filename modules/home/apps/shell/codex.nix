{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs
    mcp-nixos
    docker
  ];

  programs.codex = {
    enable = true;

    settings = {
      model = "gpt-5.6-sol";
      model_reasoning_effort = "medium";
      oss_provider = "ollama";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;

      projects."/home/xllvr/nixconf".trust_level = "trusted";

      mcp_servers = {
        context7 = {
          command = "npx";
          args = [
            "-y"
            "@upstash/context7-mcp"
          ];
        };

        nixos = {
          command = "mcp-nixos";
        };
      };
    };
  };
}
