{
  imports = [
    ../common
    ./disko.nix
    ./hardware-configuration.nix
    ../../services/consul
    ../../services/nomad
  ];

  networking.hostName = "maple";
  users.users.jake.initialPassword = "maple";
  services.consul.extraConfig.node_name = "maple";
  services.nomad.settings.server.bootstrap_expect = 3;
  services.nomad.settings.server.server_join.retry_join = [
    "cherry.hardwood.cloud"
    "hickory.hardwood.cloud"
  ];
}
