{ pkgs, ... }:
{
  imports = [
    ../common/hardwood-cluster.nix
    ./disko.nix
  ];

  networking.hostName = "cherry";
  users.users.jake.initialPassword = "cherry";
}
