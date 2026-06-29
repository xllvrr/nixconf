{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "xllvr";
    group = "users";
    dataDir = "/home/xllvr";
    configDir = "/home/xllvr/.config/syncthing";
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
  };
}
