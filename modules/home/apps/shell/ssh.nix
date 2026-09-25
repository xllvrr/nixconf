{ config, ... }:
let
  sshDir = "${config.home.homeDirectory}/.ssh";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "${sshDir}/known_hosts";
        ControlMaster = "no";
        ControlPath = "${sshDir}/master-%r@%n:%p";
        ControlPersist = "no";
      };
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "${sshDir}/github_key";
        IdentitiesOnly = true;
        AddKeysToAgent = "yes";
      };
    };
  };
}
