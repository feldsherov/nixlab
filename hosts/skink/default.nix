{ nixpkgs }:

{
  pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  modules = [
    ../../users/feldsherov.nix
  ];
}
