{
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  stylix.targets.noctalia-shell = {
    enable = false;
  };

  programs.noctalia-shell = {
    enable = true;
    settings = (builtins.fromJSON (builtins.readFile ../../../../configs/noctalia/settings.json)).settings;
  };
}
