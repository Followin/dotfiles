{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.resumeDevice = "/dev/disk/by-label/swap";

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # wifi
  networking.dhcpcd.enable = false;
  networking.wireless.iwd.enable = true;

  systemd.services.systemd-networkd = {
    # environment = {
    #   SYSTEMD_LOG_LEVEL = "debug";
    # };

    # serviceConfig = { };
  };

  # systemd.network = {
  #   enable = true;
  #   networks.wlp0 = {
  #     matchConfig.Name = "wlan0";
  #     dhcpV4Config = {
  #       RouteMetric = 100;
  #     };
  #     networkConfig = {
  #       DHCP = "ipv4";
  #       IPv6AcceptRA = false;
  #       # DNSDefaultRoute = false;
  #     };
  #   };
  # };
  #
  # services.openvpn.servers = {
  #   debvpn = {
  #     config = '' config /home/main/vpn/london.deb.ovpn '';
  #     autoStart = false;
  #     updateResolvConf = true;
  #   };
  # };
  #
  # py.wireguard = {
  #   enable = true;
  #   privateKeyFilePath = "/etc/systemd/network/wg/private";
  #   servers = [
  #     {
  #       name = "tokyo";
  #       publicKey = "1jhSgo+HqqDgbAOVIR4xI3P2tjQTpAh6DkV9sA+IXlk=";
  #       ip = "45.32.29.242";
  #     }
  #   ];
  # };
}
