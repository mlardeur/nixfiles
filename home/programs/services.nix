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

    networks.immich = {
      driver = "bridge";
    };

    volumes.open-webui = {};

    volumes.immich-model-cache = {};

    containers.ollama = {
      image = "docker.io/ollama/ollama:latest";
      autoStart = false;
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

      extraPodmanArgs = [ 
        "--dns=1.1.1.1"
        "--dns=8.8.8.8" 
      ];

      extraConfig = {
        Quadlet = {
          DefaultDependencies = "false";
        };
      };
    };

    containers.open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      autoStart = false;
      autoUpdate = "registry";

      volumes = [ "open-webui:/app/backend/data:z" ];
      ports = [ "3000:8080" ];
      network = [ "ai-net" ];

      environment = {
        OLLAMA_BASE_URL = "http://ollama:11434";
        WEBUI_AUTH = "false";
      };

      extraPodmanArgs = [ 
        "--dns=1.1.1.1"
        "--dns=8.8.8.8" 
      ];
      
      extraConfig = {
        Quadlet = {
          DefaultDependencies = "false";
        };
      };
    };

    containers.immich-ml = {
      image = "ghcr.io/immich-app/immich-machine-learning:v2.7.5-cuda";
      autoStart = false;
      autoUpdate = "registry";

      volumes = [ "immich-model-cache:/cache:z" ];
      ports = [ "3003:3003" ];
      network = [ "immich" ];

      # GPU support with CDI
      devices = [ "nvidia.com/gpu=all" ];

      environment = {
        NVIDIA_VISIBLE_DEVICES = "all";
        NVIDIA_DRIVER_CAPABILITIES = "compute,utility";
      };

      extraPodmanArgs = [ 
        "--dns=1.1.1.1"
        "--dns=8.8.8.8" 
      ];

      extraConfig = {
        Quadlet = {
          DefaultDependencies = "false";
        };
      };
    };
  };
}