{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  nvmUri = "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh";
  nodeJs = pkgs.${"nodejs_" + builtins.getEnv "NODE_VERSION"};
  nodeVersion = builtins.getEnv "NODE_VERSION";
  terraform = pkgs.writers.writeBashBin "terraform" ''
    ${pkgs.terraform}/bin/terraform "$@"
  '';
in
pkgs.mkShell {
  name = "commercetools-nix";
  buildInputs = [
    nodeJs
    terraform
    pkgs.yarn
    pkgs.ngrok
  ];
  shellHook = ''
    # Begin creating terraform environment variables specific to project
    if [ -n "$TF_VARS" ]; then
      JSON_OBJ="{}"
      JSON_FILE=$COMMERCETOOLS_PROJECT_PATH/terraform.tfvars.json

      # Start the JSON
      echo "{" > "$JSON_FILE"

      # Read each line from the environment file
      while IFS= read -r line; do
          KEY=$(echo "$line" | cut -d '=' -f 1 | tr '[:upper:]' '[:lower:]')
          LINE=$(echo "$line" | cut -d '=' -f 2-)
          VALUE=$(echo "$LINE" | sed 's/"/\\"/g')
          if [[ $KEY != *"#"* ]]; then
            echo "  \"$KEY\": \"$VALUE\"," >> "$JSON_FILE"
            export TF_VAR_$KEY=$VALUE
          fi
      done < "$COMMERCETOOLS_ENV_PATH"

      # Remove the trailing comma and close the JSON object
      sed -i '$ s/,$//' "$JSON_FILE"
      echo "}" >> "$JSON_FILE"
    fi

    # Install NVM
    # curl --no-buffer -o- ${nvmUri} | bash
    # nvm install ${nodeVersion}
    # nvm alias default ${nodeVersion}
  '';
}
