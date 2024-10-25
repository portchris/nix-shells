{ pkgs ? import <nixpkgs> { } }:
with pkgs;
with builtins;
let
  nodeVersion = builtins.getEnv "NODE_VERSION";
  nvmUri = "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh";
  nodeJs = (
    if nodeVersion == "16"
    then pkgs.vim
    else pkgs.${"nodejs_" + nodeVersion}
  );
in
pkgs.mkShell {
  name = "shopify-nix";
  buildInputs = [
    nodeJs
    pkgs.yarn
    pkgs.ngrok
  ];
  shellHook = ''

    # Use NVM to install Node.Js if below 16 as 16 is EOL for NIX packages
    if [ "${nodeVersion}" -eq "16" ]; then
      curl -o- ${nvmUri} | bash
      nvm install ${nodeVersion}
      nvm alias default ${nodeVersion}
    fi

    # npm install -g @shopify/cli@latest
  '';
}
