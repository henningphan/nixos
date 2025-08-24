{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    element-desktop
    karabiner-elements
    jq
    rectangle
    yq
    git
    iterm2
    slack
  ];
  #imports = [ ../../mac/copy-to-spotlight.nix ];

  programs.zsh = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.shells = [ pkgs.bashInteractive ];
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  nix.enable = true;


  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  networking.hostName = "devies-mbp";
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.henningphan = {
    name = "henningphan";
    shell = pkgs.zsh;
  };
  #  set mouse tracking speed but it complains its not null or float which it is which leaves me confused
  #  system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 2.0;
  system.primaryUser = "phan";
  system.defaults.universalaccess.mouseDriverCursorSize = 2.0;
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
}
