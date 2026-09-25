{ pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [ 50300 ];
}
