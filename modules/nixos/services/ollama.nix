{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [ "qwen3.5:27b-q4_K_M" ];
  };
}
