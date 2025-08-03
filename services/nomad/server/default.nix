{
  pkgs,
  ...
}:
{
  services.nomad = {
    enable = true;
    package = pkgs.nomad;

    extraSettingsPlugins = [
      pkgs.cni-plugins
      pkgs.nomad-driver-podman
    ];

    # Nomad configuration, as Nix attribute set.
    settings = {
      bind_addr = "0.0.0.0";

      server = {
        enabled = true;

        # TODO Change to 4 later
        bootstrap_expect = 1;
        # TODO set to "other three servers" in each server's configuration
        # server_join = {
        #   retry_join = [
        #   ];
        # };

        # Generated with: nomad operator gossip keyring generate
        encrypt = "hzgTmKVMb6Q9FTRgUe+23ftG8GavygixRyz3P/DLYc4=";
      };

      client = {
        enabled = false;
        cni_path = "${pkgs.cni-plugins}/bin";
      };

      consul = {
        address = "127.0.0.1:8500";
        grpc_address = "127.0.0.1:8502";

        server_service_name = "nomad-server";
        client_service_name = "nomad-client";

        auto_advertise = true;

        server_auto_join = true;
        client_auto_join = true;
      };

      acl = {
        enabled = false;
      };

      plugin = [
        {
          nomad-driver-podman = {
            config = { };
          };
        }
      ];

      telemetry = {
        collection_interval = "1s";
        disable_hostname = true;
        prometheus_metrics = true;
        publish_allocation_metrics = true;
        publish_node_metrics = true;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      4646 # API
      4647 # RPC
      4648 # Gossip
    ];

    allowedUDPPorts = [
      4648 # Gossip
    ];
  };
}
