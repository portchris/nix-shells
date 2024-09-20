{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let 
  nvmInstallScript = "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh";
  nodeVersion = builtins.getEnv "NODE_VERSION";
in
pkgs.mkShell {
  name = "shopify-nix";
  buildInputs = [
    ngrok
  ];
  shellHook = ''    
    curl -o- ${nvmInstallScript} | bash
    nvm install ${nodeVersion}
    nvm alias default ${nodeVersion}
    npm install -g @shopify/cli@latest
  '';
}

