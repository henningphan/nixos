# rebuild darwin
##Only do the add the first time
nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin

nix-channel --update darwin
## Make darwin-config point to darwin-configuration.nix in the repo
export NIX_PATH=darwin-config=../darwin-configuration.nix
darwin-rebuild switch

# home-manager
home-manager switch --flake ~/repo/nixconf
