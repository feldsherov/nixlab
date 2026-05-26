{
  description = "nixlab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code.url = "github:sadjow/claude-code-nix";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, claude-code, lanzaboote, ... }:
    let
      homeManagerHosts = [ "skink" ];
    in {
      nixosConfigurations = {
        newt = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/newt/default.nix
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [ claude-code.overlays.default ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.feldsherov = import ./users/feldsherov.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };

      homeConfigurations = builtins.listToAttrs (map (name:
        let host = import ./hosts/${name} { inherit nixpkgs; }; in {
          inherit name;
          value = home-manager.lib.homeManagerConfiguration {
            inherit (host) pkgs modules;
          };
        }
      ) homeManagerHosts);
    };
}
