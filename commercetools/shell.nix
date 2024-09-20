{ pkgs ? import <nixpkgs> { } }:
let
  terraform = pkgs.writers.writeBashBin "terraform" ''
    ${pkgs.terraform}/bin/terraform "$@"
  '';
in
pkgs.mkShell {
  buildInputs = [
    terraform
    pkgs.ngrok
  ];
  shellHook = ''
    set -a
    source $COMMERCETOOLS_ENV_PATH
    set +a

    # Begin creating terraform environment variables specific to project
    JSON_OBJ="{}"
    JSON_FILE=$COMMERCETOOLS_PROJECT_PATH/terraform.tfvars.json

    # Start the JSON
    echo "{" > "$JSON_FILE"

    # Read each line from the environment file
    while IFS= read -r line; do
        KEY=$(echo "$line" | cut -d '=' -f 1 | tr '[:upper:]' '[:lower:]')
        LINE=$(echo "$line" | cut -d '=' -f 2-)
        VALUE=$(echo "$LINE" | sed 's/"/\\"/g')
        echo "  \"$KEY\": \"$VALUE\"," >> "$JSON_FILE"
	export TF_VAR_$KEY=$VALUE
    done < "$COMMERCETOOLS_ENV_PATH"

    # Remove the trailing comma and close the JSON object
    sed -i '$ s/,$//' "$JSON_FILE"
    echo "}" >> "$JSON_FILE"
  '';
}

