{
  imports = [
    ../common
    ./disko.nix
    ./hardware-configuration.nix
    ../../services/consul
    ../../services/nomad
  ];

  networking.hostName = "cherry";
  users.users.jake.initialPassword = "cherry";
  services.consul.extraConfig.node_name = "cherry";
}
