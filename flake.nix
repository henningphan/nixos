{
  description = "Home Manager configuration of henning";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-firefox-darwin,
      nur,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs_aarch64-darwin = nixpkgs.legacyPackages.${system};
      pkgs_x86_64-linux = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      formatter.x86_64-linux = pkgs_x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-darwin = pkgs_aarch64-darwin.nixfmt-rfc-style;
      homeConfigurations."henning@devies-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_aarch64-darwin;
        modules = [
          {
            nixpkgs.overlays = [
              nixpkgs-firefox-darwin.overlay
              nur.overlay
            ];
          }
          ./hosts/devies-mbp/henning.hm.nix
        ];
      };
      homeConfigurations."phan@devies-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_aarch64-darwin;
        modules = [
          {
            nixpkgs.overlays = [
              nixpkgs-firefox-darwin.overlay
              nur.overlay
            ];
          }
          ./hosts/devies-mbp/phan.hm.nix
        ];
      };
      homeConfigurations."henning@nixos-shuttle" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_x86_64-linux;
        modules = [ ./hosts/nixos-shuttle/henning.hm.nix ];
      };
    };
}
