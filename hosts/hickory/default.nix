{
  imports = [
    ../common
    ./disko.nix
    ./hardware-configuration.nix
    ../../services/consul
    ../../services/nomad
  ];

  networking.hostName = "hickory";
  users.users.jake.initialPassword = "hickory";
  services.consul.extraConfig.node_name = "hickory";
  services.consul.extraConfig.bootstrap_expect = 3;
  services.consul.extraConfig.retry_join = [
    "cherry.hardwood.cloud"
    "mapple.hardwood.cloud"
  ];
  services.nomad.settings.server.bootstrap_expect = 3;
  services.nomad.settings.server.server_join.retry_join = [
    "cherry.hardwood.cloud"
    "mapple.hardwood.cloud"
  ];
}
