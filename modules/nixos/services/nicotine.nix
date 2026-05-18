{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nicotine-plus
  ];

  networking.firewall.allowedTCPPorts = [50300];
}
