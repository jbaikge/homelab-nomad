{
  pkgs,
  clusterConfig,
  ...
}:
{
  services.nomad = {
    enable = true;
    package = pkgs.nomad;

    extraPackages = [
      pkgs.cni-plugins
    ];

    enableDocker = true;

    extraSettingsPlugins = [ ];

    dropPrivileges = false;

    settings = {
      bind_addr = "0.0.0.0";
      datacenter = "dc1";
      leave_on_interrupt = true;
      leave_on_terminate = true;

      advertise = {
        http = "{{ GetPrivateInterfaces | include \"network\" \"10.100.6.0/24\" | attr \"address\" }}";
        rpc = "{{ GetPrivateInterfaces | include \"network\" \"10.100.6.0/24\" | attr \"address\" }}";
        serf = "{{ GetPrivateInterfaces | include \"network\" \"10.100.6.0/24\" | attr \"address\" }}";
      };

      client = {
        enabled = true;
        servers = clusterConfig.serverNames;
        cni_path = "${pkgs.cni-plugins}/bin";
        artifact = {
          disable_filesystem_isolation = true;
        };
        drain_on_shutdown = {
          deadline = "5m";
          force = false;
          ignore_system_jobs = false;
        };
      };

      server = {
        enabled = false;
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

      plugin = {
        docker = {
          config = {
            allow_privileged = true;
          };
        };
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      4646
      4647
      4648
      9998
    ];

    allowedUDPPorts = [
      4648
    ];
  };
}
