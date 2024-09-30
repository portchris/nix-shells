{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  nvmUri = "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh";
  nodeJs = pkgs.${"nodejs_" + builtins.getEnv "NODE_VERSION"};
  nodeVersion = builtins.getEnv "NODE_VERSION";
in
pkgs.mkShell {
  name = "shopify-nix";
  buildInputs = [
    nodeJs
    pkgs.yarn
    pkgs.ngrok
  ];
  shellHook = ''
    # curl -o- ${nvmUri} | bash
    # nvm install ${nodeVersion}
    # nvm alias default ${nodeVersion}
    # npm install -g @shopify/cli@latest
  '';
}
