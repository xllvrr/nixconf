{inputs, configRoot, ...}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    # Settings are tracked in this repo. Export current state with:
    #   noctalia-shell ipc call state all | jq .settings > ~/nixconf/configs/noctalia/settings.json
    settings = configRoot + "/noctalia/settings.json";
  };
}
