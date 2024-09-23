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
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixpkgs-firefox-darwin,
      nur,
      nix-darwin,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs_aarch64-darwin = nixpkgs.legacyPackages.${system};
      pkgs_x86_64-linux = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      darwinSystem = nix-darwin.lib.darwinSystem;
    in
    {
      formatter.x86_64-linux = pkgs_x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-darwin = pkgs_aarch64-darwin.nixfmt-rfc-style;

      darwinConfigurations.devies-mbp = darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/devies-mbp/darwin-configuration.nix
        ];
      };
      nixosConfigurations."nixos-shuttle" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-shuttle/configuration.nix
        ];
      };

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
