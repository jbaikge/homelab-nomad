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
  services.consul.extraConfig.bootstrap_expect = 3;
  services.consul.extraConfig.retry_join = [
    "hickory.hardwood.cloud"
    "mapple.hardwood.cloud"
  ];
  services.nomad.settings.server.bootstrap_expect = 3;
  services.nomad.settings.server.server_join.retry_join = [
    "hickory.hardwood.cloud"
    "mapple.hardwood.cloud"
  ];
}
