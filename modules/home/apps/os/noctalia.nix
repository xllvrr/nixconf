{
  inputs,
  repoRoot,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = repoRoot + "/configs/noctalia/config.toml";
  };
}
