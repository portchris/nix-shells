REPO=$1

# Ensure repo directory exists and environment variables are present
if [ -z "$REPO" ]; then
        echo "Please provide the repository name to load:"
        read REPO
fi

if [ ! -f "$REPO/.env" ]; then
        echo "An environment file doesn't exist in $REPO/.env - please create one and try again:"
fi

# Set-up environment variables
CWD=${PWD}
COMMERCETOOLS_PROJECT_PATH=$CWD/$REPO
COMMERCETOOLS_ENV_PATH=$COMMERCETOOLS_PROJECT_PATH/.env
export COMMERCETOOLS_PROJECT_PATH=$COMMERCETOOLS_PROJECT_PATH
export COMMERCETOOLS_ENV_PATH=$COMMERCETOOLS_ENV_PATH
export NIXPKGS_ALLOW_UNFREE=1

# Run NIX shell
cd $COMMERCETOOLS_PROJECT_PATH
nix-shell $CWD/shell.nix
