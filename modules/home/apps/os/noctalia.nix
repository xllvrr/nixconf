{
  inputs,
  repoRoot,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # v4 rollback:
  #
  # stylix.targets.noctalia-shell = {
  #   enable = false;
  # };
  #
  # programs.noctalia-shell = {
  #   enable = true;
  #   settings =
  #     (builtins.fromJSON (builtins.readFile (repoRoot + "/configs/noctalia/settings.json"))).settings;
  # };

  programs.noctalia = {
    enable = true;
    settings = repoRoot + "/configs/noctalia/config.toml";
  };
}
