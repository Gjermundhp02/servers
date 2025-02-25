# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gjermund = {
    isNormalUser = true;
    description = "Gjermund";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = let
      authorizedKeys = builtins.fetchurl {
        url = "https://github.com/gjermundhp02.keys";
        sha256 = "sha256:1gc1c8syv70j25s8g8lifxh9prp9hn4hcf2kdbig4hihsi8hjrgw";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile
    authorizedKeys);
  };

  environment.systemPackages = with pkgs; [
  
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      website = {
        image = "ghcr.io/gjermundhp02/website:latest";
        ports = [
          "80:3000"
        ];
      };
    };
  };
  

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}