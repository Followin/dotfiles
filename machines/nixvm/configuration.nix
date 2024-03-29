{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  networking.extraHosts = ''
    10.45.16.8 pxdevaks001-b5o4ylsd.999bd9f0-b7c7-4e9f-af42-467292a14e36.privatelink.westeurope.azmk8s.io
  '';
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp0s8";
    networkConfig.DHCP = "ipv4";
    networkConfig.MulticastDNS = true;
    networkConfig.LinkLocalAddressing = false;
  };
}
