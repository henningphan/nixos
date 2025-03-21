# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixosmodules/nvim.nix
    ../../nixosmodules/immich
    ../../nixosmodules/tmux.nix
    ../../nixosmodules/servarr
    ../../nixosmodules/nfs.nix
  ];
  #  nixpkgs.config.packageOverrides = pkgs: {
  #      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  #  };
  servarr = {
    enable = true;
    plexHardwareAcceleration = true;
  };

  virtualisation.docker.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    defaultGateway = "192.168.1.1";
    hostName = "nixos-shuttle";
    interfaces.enp1s0.ipv4.addresses = lib.mkForce [ ];
    nameservers = [ "192.168.1.1" ];
    useDHCP = false;
    # networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    macvlans = {
      mv-enp1s0-host = {
        mode = "bridge";
        interface = "enp1s0";
      };
    };
    interfaces.mv-enp1s0-host = {
      ipv4.addresses = [
        {
          address = "192.168.1.11";
          prefixLength = 24;
        }
      ];
    };
  };

  nix.nixPath = [
    (
      "nixos-config="
      + "/home/henning/repo/nixconf/hosts/nixos-shuttle/configuration.nix"
      + ":/nix/var/nix/profiles/per-user/root/channels"
    )
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  #   i18n.defaultLocale = "se_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # Keymaps can be found at /run/current-system/kbd/keymaps/i386
    keyMap = "dvorak-sv-a5";
  };
  #
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.henning = {
    isNormalUser = true;
    initialPassword = "henning";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjhMFz8P0mf+LPfHeMI9FMVVt65cAXKp1T9fTtgpjMG nixos-msi@h.phan.se"
    ];
    extraGroups = [
      "docker"
      "servarr"
      "wheel"
      "immich"
    ];
    packages = with pkgs; [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    home-manager
    silver-searcher
    wget
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    111
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
