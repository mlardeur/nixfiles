{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "zion" = {
        hostname = "192.168.1.2";
        user = "zion";
      };
    };
  };
}
