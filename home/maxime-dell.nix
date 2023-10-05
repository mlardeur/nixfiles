{inputs, lib, config, pkgs, ...}:

{
  imports = [
    ./cli
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };  

  home = {
    username = "mlardeur";
    homeDirectory = "/home/mlardeur";
    stateVersion = "23.05";    

    packages = with pkgs; [
    ];
  };

  programs.home-manager.enable = true;
}
