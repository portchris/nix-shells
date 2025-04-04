{
  description = "Shopify / Node.Js NIX Flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, nixpkgs-ruby, ... }:

        let
          shopify-cli = pkgs.callPackage
            (pkgs.fetchFromGitHub {
              owner = "mrhenry";
              repo = "nix-shopify-cli";
              rev = "5d8c3ab7ed959fbc4c2c772e2fdaffce901fb5e2";
              sha256 = "sha256-RZG2XLBiXzS6NfN4m2JUIqf9K0pxUKYUK6bGpSu0Xac=";
            })
            { };
        in
        {
          packages = {
            nodejs16 = pkgs.stdenv.mkDerivation {
              name = "nodejs16.0.0";
              src = pkgs.fetchurl {
                url = "https://nodejs.org/dist/v16.0.0/node-v16.0.0-darwin-arm64.tar.gz";
                sha256 = "sha256-LW1BKrz3yTdfGf3hQIamQj5buUFe7KHMrUljj/xHbqM=";
              };
              installPhase = ''
                echo "installing nodejs"
                mkdir -p $out
                cp -r ./ $out/
              '';
            };
          };
          devShells = {
            default = pkgs.mkShell {
              packages = with pkgs; [
                nodejs
              ];
            };
            node_16 = pkgs.mkShell {
              packages = with pkgs; [
                nodePackages_latest.vercel
                httpie
                self'.packages.nodejs16
                fnm
                corepack
              ];
            };
            node_18 = pkgs.mkShell {
              packages = with pkgs; [
                nodePackages_latest.vercel
                httpie
                nodejs_18
                (yarn.override {
                  nodejs = nodejs_18;
                })
              ];
            };
            nodejs_20 = pkgs.mkShell {
              packages = with pkgs; [
                nodePackages_latest.vercel
                httpie
                nodejs_20
                (yarn.override {
                  nodejs = nodejs_20;
                })
              ];
            };
            liquidtheme = pkgs.mkShell {
              packages = with pkgs; [
                nodePackages_latest.vercel
                ruby
                httpie
                nodejs_18
                (yarn.override {
                  nodejs = nodejs_18;
                })
                shopify-cli
              ];
            };
            cue = pkgs.mkShell {
              packages = with pkgs; [
                corepack_21
                httpie
                nodejs_20
              ];
            };
            quitelike = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                playwright
                playwright-driver.browsers
              ];
              packages = with pkgs; [
                nodejs_20
                (yarn.override {
                  nodejs = nodejs_20;
                })
              ];

              PLAYWRIGHT_NODEJS_PATH = "${pkgs.nodejs}/bin/node";
              PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
              PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;

              shellHook = ''
                echo "dev env started"
              '';
            };
            sns = pkgs.mkShell
              {
                buildInputs = with pkgs; [
                  nodejs_18
                  (yarn.override {
                    nodejs = nodejs_18;
                  })
                  httpie
                  cairo
                  pango
                  pkg-config
                  nodePackages.node-gyp
                  libpng
                  librsvg
                  pixman
                  giflib
                  libjpeg
                  hugo
                  ruby
                  darwin.apple_sdk.frameworks.CoreFoundation
                  darwin.apple_sdk.frameworks.CoreServices
                  darwin.apple_sdk.frameworks.CoreText
                ];
                shellHook = ''
                  LD=$CC
                  export LD_LIBRARY_PATH="$APPEND_LIBRARY_PATH:$LD_LIBRARY_PATH"
                '';
                packages = with pkgs; [
                  shopify-themekit
                  nodejs_18
                  (yarn.override {
                    nodejs = nodejs_18;
                  })
                  shopify-cli
                ];
              };
          };
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          # packages.default = pkgs.hello;
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
