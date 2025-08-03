{
  description = "Nomad homelab cluster";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.05";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { nixpkgs, disko, ... }:
    let
      clusterConfig = {
        serverNames = [
          "cherry.hardwood.cloud"
        ];
      };
    in
    {
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./hosts/iso
          ];
        };
        cherry = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            ./hosts/cherry
          ];
          specialArgs = { inherit clusterConfig; };
        };
      };
    };
}
