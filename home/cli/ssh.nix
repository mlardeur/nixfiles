{ config, pkgs, ... }:

{
  
  home.packages = with pkgs; [
    sops
    age
  ];

  # Configuration sops
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/ssh.yaml;
    
    secrets = {
      ssh_private_key = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
      ssh_public_key = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        mode = "0644";
      };
    };
  };  
  
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "zion" = {
        hostname = "192.168.1.4";
        user = "zion";
        addKeysToAgent = "yes";
      };
      "nebula" = {
        hostname = "192.168.1.8";
        addKeysToAgent = "yes";
      };
    };
  };

  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 600 ~/.ssh/config'';
  };
}
