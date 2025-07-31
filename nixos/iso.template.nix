{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    # <nixpkgs/nixos/modules/installer/netboot/netboot.nix>
  ];

  # This is required to get past the screen that says the ISO isn't UEFI
  # compatible
  isoImage.forceTextMode = true;

  # These seem to be required to add? I ended up trying in a USB2 port and
  # suddenly things started working?
  boot.initrd.kernelModules = [
    "ahci"
    "uas"
    "ehci_pci"
    "xhci_pci"
    "usb_storage"
  ];

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;

  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "${sshKey}"
    ];

    isNormalUser = true;
    description = "${fullName}";
    extraGroups = [ "wheel" ];
    initialHashedPassword = "${hashedPassword}";
    shell = pkgs.zsh;
    packages = [ ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.curl
    pkgs.damon # TUI for Nomad.
    pkgs.git
    pkgs.nomad-driver-podman # Podman driver plugin.
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.zsh.enable = true;

  services.openssh.enable = true;
  services.nomad = {
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
      client.enabled = true;
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
      plugin = [{
        nomad-driver-podman = {
          config = { };
        };
      }];
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
