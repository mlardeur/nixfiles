{ inputs, pkgs, config, lib, ... }:

let
  # Helper function to decrypt secrets at build time
  decryptSecret = secretPath: placeholder:
    pkgs.runCommand "decrypt-${baseNameOf secretPath}"
      {
        buildInputs = [ pkgs.sops ];
      } ''
      export SOPS_AGE_KEY_FILE=${config.sops.age.keyFile}
      sops -d --extract '${placeholder}' ${secretPath} > $out
    '';
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../home/cli
    ../../home/desktop
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark;

  systemd.user.startServices = "sd-switch";
  # Completely disable the systemd service
  systemd.user.services.sops-nix = lib.mkForce { };

  sops = {
    # Don't validate signatures in toolbox (causes issues)
    validateSopsFiles = false;
  };

  home.activation = {
    # Run sops secret activation after home-manager switch
    activateSopsSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD echo "🔐 Activating sops secrets manually..."
      
      # Only run if we're not in a dry-run and sops is available
      if [ -z "$DRY_RUN_CMD" ]; then
        export SOPS_AGE_KEY_FILE="${config.sops.age.keyFile}"
        
        SOPS_BIN="${pkgs.sops}/bin/sops"
        if [ ! -x "$SOPS_BIN" ]; then
          echo "ERROR: sops binary not found at $SOPS_BIN" >&2
          exit 1
        fi

        # Decrypt each secret
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: secret: ''
          $DRY_RUN_CMD echo "🔐 Decrypting secret: ${name} to ${secret.path}"
          $DRY_RUN_CMD mkdir -p "$(dirname "${secret.path}")"
          $DRY_RUN_CMD "$SOPS_BIN" -d --extract '["${name}"]' "${config.sops.defaultSopsFile}" > "${secret.path}" 2>/dev/null || true
          $DRY_RUN_CMD chmod ${secret.mode or "0400"} "${secret.path}"
        '') config.sops.secrets)}
        $DRY_RUN_CMD echo "✅ Sops secrets activated"
      fi
    '';
  };



  # Home Manger needs a bit of information about you and the 
  # paths is should manage.
  home = {
    username = "mlardeur";
    homeDirectory = "/var/home/mlardeur";
    stateVersion = "25.05";

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
