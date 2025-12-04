{
  description = "Home Manager configuration of henning";

  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nixpkgs-firefox-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixpkgs-firefox-darwin,
      nur,
      sops-nix,
      nix-darwin,
      deploy-rs,
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

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      darwinConfigurations.devies-mbp = darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/devies-mbp/darwin-configuration.nix
        ];
      };
      lib.vcc = import ./hosts/vcc/configuration.nix;
      nixosConfigurations.vcc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs_x86_64-linux;
        modules = [
          ./hosts/vcc/configuration.nix
        ];
      };
      homeConfigurations."vcc@vcc" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_x86_64-linux;
        modules = [
          {
            nixpkgs.overlays = [
              nur.overlays.default
            ];
          }
          ./hosts/vcc/vcc.hm.nix
        ];
      };
      homeConfigurations."henning@devies-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_aarch64-darwin;
        modules = [
          {
            nixpkgs.overlays = [
              nixpkgs-firefox-darwin.overlay
              nur.overlays.default
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
              nur.overlays.default
            ];
          }
          ./hosts/devies-mbp/phan.hm.nix
        ];
      };
      homeConfigurations."henning@shuttle" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_x86_64-linux;
        modules = [ ./hosts/shuttle/henning.hm.nix ];
      };
      homeConfigurations."henning@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_x86_64-linux;
        modules = [ ./hosts/sofac/henning.hm.nix ];
      };
    };
}
