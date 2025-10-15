# Using sops-nix in Nix-Toolbox

## The Problem

Nix-toolbox runs in a container without a proper systemd user session, so `sops-nix.service` cannot start automatically. However, you can still use sops-nix with manual activation!

## Solution: Manual Secret Activation

### Step 1: Setup Age Key

```bash
# Create age key directory
mkdir -p ~/.config/sops/age

# Generate age key
age-keygen -o ~/.config/sops/age/keys.txt

# Note the public key for encrypting secrets
cat ~/.config/sops/age/keys.txt | grep "# public key:"
```

### Step 2: Create Secrets File

Create `~/.config/sops/secrets.yaml` with your secrets:

```yaml
# Example secrets file
github_token: ENC[AES256_GCM,data:...,type:str]
ssh_private_key: ENC[AES256_GCM,data:...,type:str]
api_keys:
  openai: ENC[AES256_GCM,data:...,type:str]
```

To create this file:

```bash
# Create plain secrets file first
cat > ~/.config/sops/secrets.yaml.plain << EOF
github_token: ghp_your_token_here
ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  your_key_here
  -----END OPENSSH PRIVATE KEY-----
api_keys:
  openai: sk-your-openai-key
EOF

# Get your age public key
AGE_PUBLIC_KEY=$(grep "public key:" ~/.config/sops/age/keys.txt | cut -d: -f2 | tr -d ' ')

# Encrypt with sops
sops --age $AGE_PUBLIC_KEY \
     --encrypt ~/.config/sops/secrets.yaml.plain \
     > ~/.config/sops/secrets.yaml

# Remove plaintext file
shred -u ~/.config/sops/secrets.yaml.plain
```

### Step 3: Configure Home Manager

Use **Option 3** from the artifacts above - the one with `home.activation`.

Key parts:

```nix
{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;  # or ~/.config/sops/secrets.yaml
    validateSopsFiles = false;  # Important for toolbox!
    
    secrets = {
      github_token = {
        path = "${config.home.homeDirectory}/.config/github/token";
      };
    };
  };
  
  # Disable systemd service
  systemd.user.services.sops-nix = lib.mkForce {};
  
  # Manual activation via home.activation
  home.activation.activateSopsSecrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # ... see artifact for full code
  '';
}
```

### Step 4: Apply Configuration

```bash
# Inside nix-toolbox
home-manager switch
```

Secrets will be decrypted during the activation phase!

### Step 5: Verify Secrets

```bash
# Check if secrets were decrypted
cat ~/.config/github/token

# List all secret files
ls -la ~/.config/github/
ls -la ~/.ssh/sops_*
```

## Alternative: Simple Shell Script Approach

If the Home Manager activation doesn't work well, use a simple script:

1. **Create activation script** at `~/.local/bin/activate-secrets`:

```bash
#!/usr/bin/env bash
export SOPS_AGE_KEY_FILE="${HOME}/.config/sops/age/keys.txt"

# Decrypt github token
mkdir -p "${HOME}/.config/github"
sops -d --extract '["github_token"]' "${HOME}/.config/sops/secrets.yaml" \
  > "${HOME}/.config/github/token"
chmod 600 "${HOME}/.config/github/token"

# Decrypt SSH key
sops -d --extract '["ssh_private_key"]' "${HOME}/.config/sops/secrets.yaml" \
  > "${HOME}/.ssh/sops_id_ed25519"
chmod 600 "${HOME}/.ssh/sops_id_ed25519"

echo "✅ Secrets activated"
```

2. **Make it executable:**

```bash
chmod +x ~/.local/bin/activate-secrets
```

3. **Run on shell startup** - add to `~/.bashrc` or `~/.zshrc`:

```bash
# Activate sops secrets
if [ -f "$HOME/.local/bin/activate-secrets" ]; then
  "$HOME/.local/bin/activate-secrets" 2>/dev/null
fi
```

4. **Or run manually** when needed:

```bash
activate-secrets
```

## Managing Secrets

### Edit Secrets

```bash
# Edit encrypted secrets file
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
sops ~/.config/sops/secrets.yaml
```

### Add New Secret

```bash
# Edit the file
sops ~/.config/sops/secrets.yaml

# Add your new secret, save and exit

# Re-run activation
activate-secrets  # or home-manager switch
```

### Rotate Age Key

```bash
# Generate new key
age-keygen -o ~/.config/sops/age/keys-new.txt

# Re-encrypt secrets with new key
NEW_KEY=$(grep "public key:" ~/.config/sops/age/keys-new.txt | cut -d: -f2 | tr -d ' ')
sops updatekeys --age $NEW_KEY ~/.config/sops/secrets.yaml

# Replace old key
mv ~/.config/sops/age/keys-new.txt ~/.config/sops/age/keys.txt
```

## Using Secrets in Applications

### Example: Git with GitHub Token

```nix
programs.git = {
  enable = true;
  extraConfig = {
    credential.helper = "store --file ${config.home.homeDirectory}/.config/github/token";
  };
};
```

### Example: SSH Config

```nix
programs.ssh = {
  enable = true;
  matchBlocks = {
    "github.com" = {
      identityFile = "${config.home.homeDirectory}/.ssh/sops_id_ed25519";
    };
  };
};
```

### Example: Environment Variables

```bash
# In your shell config
export OPENAI_API_KEY="$(cat ~/.config/openai/key)"
```

## Troubleshooting

### "no such file or directory" error

Make sure secrets are activated:
```bash
activate-secrets
```

### "failed to get data key" error

Check age key path:
```bash
ls -la ~/.config/sops/age/keys.txt
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
```

### Secrets not persisting after reboot

Add activation script to shell startup (see above).

### Want to check if secret is encrypted correctly

```bash
# View encrypted file
cat ~/.config/sops/secrets.yaml

# Decrypt to stdout (doesn't save)
sops -d ~/.config/sops/secrets.yaml
```

## Best Practices

1. ✅ **Keep age key backed up** - Store `~/.config/sops/age/keys.txt` securely
2. ✅ **Use different secrets per machine** if needed
3. ✅ **Set proper file permissions** (600 for keys, 400 for secrets)
4. ✅ **Add secrets.yaml to git** (it's encrypted!)
5. ❌ **Never commit the age private key** (add to .gitignore)
6. ❌ **Never commit decrypted secrets**

## Migration to Native Nix

When native Nix installation works on Fedora 42:

1. Install Nix natively
2. Remove the `systemd.user.services.sops-nix = lib.mkForce {};` line
3. Remove manual activation code
4. Run `home-manager switch`
5. Systemd will handle secrets automatically! 🎉

Until then, manual activation works perfectly fine!
