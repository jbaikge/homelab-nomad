{
  imports = [
    ../common
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "cherry";
  users.users.jake.initialPassword = "cherry";
}
