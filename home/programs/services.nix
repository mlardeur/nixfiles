{ config, pkgs, ... }:

{
  # Activation du linger pour démarrage automatique sans session
  systemd.user.startServices = "sd-switch";
  
  # Variables d'environnement pour CUDA
  home.sessionVariables = {
    CUDA_VISIBLE_DEVICES = "0";
    OLLAMA_HOST = "http://127.0.0.1:11434";
  };
  
  # Activation des services utilisateur Podman
  services.podman = {
    enable = true;
    autoUpdate.enable = true;
  };
  
  # --- DÉFINITION DES CONTENEURS AVEC QUADLET ---
  virtualisation.quadlet = {
    # Volumes persistants
    volumes = {
      "ollama-models" = {
        volumeConfig = {
          label = "ollama-models";
        };
      };
    };
    
    # Conteneur Ollama avec GPU
    containers = {
      "ollama" = {
        autoStart = true;
        serviceConfig = {
          Restart = "always";
          RestartSec = "10";
        };
        containerConfig = {
          image = "docker.io/ollama/ollama:latest";
          volumes = [ "ollama-models:/root/.ollama" ];
          publishPorts = [ "127.0.0.1:11434:11434" ];
          environment = {
            CUDA_VISIBLE_DEVICES = "0";
            OLLAMA_KEEP_ALIVE = "0";
          };
          # Accès GPU NVIDIA
          devices = [ "nvidia.com/gpu=all" ];
          # Arguments supplémentaires si nécessaire
          podmanArgs = [ "--security-opt=label=disable" ];
        };
      };
      
      # Conteneur Open WebUI (interface pour Ollama)
      "open-webui" = {
        autoStart = true;
        containerConfig = {
          image = "ghcr.io/open-webui/open-webui:main";
          publishPorts = [ "127.0.0.1:3000:8080" ];
          volumes = [ "open-webui-data:/app/backend/data" ];
          environment = {
            OLLAMA_BASE_URL = "http://ollama:11434";
          };
          # Dépendance explicite
          dependsOn = [ "ollama.service" ];
        };
      };
    };
  };
}