# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
  config, pkgs, ... 
}: {
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = let
      authorizedKeys = builtins.fetchurl {
        url = "https://github.com/gjermundhp02.keys";
        sha256 = "sha256:11j5fv71wwy04v2x6qqwn32b1xn0qmx5kips78fazqa5yi2i8w3f";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };

  services.qemuGuest.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.05";
}