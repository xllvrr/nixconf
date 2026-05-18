{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options = {baseURL = "http://localhost:11434/v1";};
          models = {
            "gemma4:latest" = {name = "Gemma4";};
          };
        };
      };
    };
  };
}
