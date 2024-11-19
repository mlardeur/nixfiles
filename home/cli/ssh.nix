{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "zion" = {
        hostname = "192.168.1.4";
        user = "zion";
      };
      "nebula" = {
        hostname = "192.168.1.8";
      };
    };
  };

  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 600 ~/.ssh/config'';
  };
}
