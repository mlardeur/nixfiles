{ config, pkgs, ... }:

{
  # opencode CLI itself is managed by programs.opencode below; only the
  # desktop app stays a plain package.
  home.packages = [ pkgs.opencode-desktop ];

  programs.opencode = {
    enable = true;
    package = pkgs.opencode;

    settings = {
      disabled_providers = [ ];
      provider.ollama_local = {
        name = "Ollama";
        npm = "@ai-sdk/openai-compatible";
        options.baseURL = "http://localhost:11434/v1";
        models = {
          "qwen3:14b" = {
            name = "Qwen3 14B";
            limit = {
              context = 32768;
              output = 8192;
            };
          };
          "gemma4:26b" = {
            name = "Gemma4";
            limit = {
              context = 32768;
              output = 8192;
            };
          };
        };
      };
      shell = "/run/current-system/sw/bin/bash";
    };

    # Headless `opencode serve` exposed to the LAN so the official
    # opencode Android app can connect. Port 4097 because 4096 is already
    # taken by the JetBrains ACP instance of opencode.
    web = {
      enable = true;
      extraArgs = [
        "--hostname"
        "0.0.0.0"
        "--port"
        "4097"
      ];
      environmentFile = config.sops.secrets.opencode_server_password.path;
    };
  };

  # OPENCODE_SERVER_PASSWORD lives in a sops secret rendered to a tmpfs path
  # outside the Nix store; systemd loads it as an EnvironmentFile (KEY=VALUE).
  sops.secrets.opencode_server_password = {
    sopsFile = ../../secrets/env.yaml;
    mode = "0400";
  };
}
