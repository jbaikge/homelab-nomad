{
  lib,
  pkgs,
  ...
}:
{
  services.consul = {
    enable = true;
    package = pkgs.consul;

    extraConfig = {
      server = true;
      rejoin_after_leave = true;
      ui = true;
      ui_config.enabled = true;

      client_addr = "0.0.0.0";
      advertise_addr = "{{ GetPrivateInterfaces | include \"network\" \"10.100.6.0/24\" | attr \"address\" }}";

      bootstrap_expect = lib.mkDefault 1;
      retry_join = lib.mkDefault [ ];

      datacenter = "dc1";
      node_name = lib.mkDefault "unknown";

      encrypt = "pJgXpTzlDm3zC9GFoM5jtP9/TYsY1EikpGtPGJP6sOU=";

      connect = {
        enabled = true;
      };

      ports = {
        grpc = 8502;
        dns = 8600;
      };

      recursors = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    8500
    8501
    8502
    8503
    8600
    8300
    8301
    8302
  ];
  networking.firewall.allowedUDPPorts = [
    8600
    8300
    8301
    8302
  ];
}
