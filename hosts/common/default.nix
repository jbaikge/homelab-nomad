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

  time.timeZone = "America/New_York";

  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        8080 # Treafik HTTP (test)
        8081 # Traefik API (test)
      ];
      allowedUDPPorts = [
        53 # DNS
      ];
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
    pkgs.git
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
