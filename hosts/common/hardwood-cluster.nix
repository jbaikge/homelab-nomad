{ pkgs, ... }:
{
  imports = [
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
    };
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKcUwPKD4XVY/CD36DrBhlQkUq3AzKaNpfHb0S5ZqQB"
      ];
    };

    jake = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwt0GaEQ9qFE/P7LRLEKqDtMF9zbSFtgO3wLq4XZxyM"
      ];

      isNormalUser = true;
      description = "Jacob Tews";
      extraGroups = [ "wheel" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.curl
    pkgs.damon # TUI for Nomad.
    pkgs.git
    pkgs.nomad-driver-podman # Podman driver plugin.
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  services = {
    openssh = {
      enable = true;
    };

    nomad = {
      enable = true;
      # package = pkgs.nomad_1_6;

      # Add extra plugins to Nomads plugin directory.
      extraSettingsPlugins = [ pkgs.nomad-driver-podman ];

      # Add Docker driver.
      enableDocker = true;

      # Nomad as Root to access Docker/Podman sockets.
      dropPrivileges = false;

      # Nomad configuration, as Nix attribute set.
      settings = {
        client = {
          enabled = true;
        };
        server = {
          enabled = true;
          # TODO Change to 4 later
          bootstrap_expect = 1;
          # TODO set to "other three servers" in each server's configuration
          # server_join = {
          #   retry_join = [
          #   ];
          # };
        };
        ui = {
          enabled = true;
        };
        plugin = [
          {
            nomad-driver-podman = {
              config = { };
            };
          }
        ];
      };
    };
  };

  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
      dockerSocket.enable = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  system.stateVersion = "25.05";
}
