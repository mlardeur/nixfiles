{ config, pkgs, ... }:

{
  systemd.user.tmpfiles.rules = [
    "d %h/.ollama 0755 - - -"
  ];
  
  services.podman = {
    enable = true;
    autoUpdate.enable = true;

    networks.ai-net = {
      driver = "bridge";
    };

    volumes.open-webui = {};

    containers.ollama = {
      image = "docker.io/ollama/ollama:latest";
      autoStart = true;
      autoUpdate = "registry";

      volumes = [ "%h/.ollama:/root/.ollama:z" ];
      ports = [ "11434:11434" ];
      network = [ "ai-net" ];

      # Option native — pas besoin d'extraPodmanArgs
      devices = [ "nvidia.com/gpu=all" ];  # CDI (recommandé)

      environment = {
        OLLAMA_HOST = "0.0.0.0";
        NVIDIA_VISIBLE_DEVICES = "all";
        NVIDIA_DRIVER_CAPABILITIES = "compute,utility";
      };

      extraConfig = {
        Quadlet = {
          DefaultDependencies = "false";
        };
      };
    };

    containers.open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      autoStart = true;
      autoUpdate = "registry";

      volumes = [ "open-webui:/app/backend/data:z" ];
      ports = [ "3000:8080" ];
      network = [ "ai-net" ];

      environment = {
        OLLAMA_BASE_URL = "http://ollama:11434";
        WEBUI_AUTH = "false";
      };

      extraConfig = {
        Quadlet = {
          DefaultDependencies = "false";
        };
      };
    };
  };
}