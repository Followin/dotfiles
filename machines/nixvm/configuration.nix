{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.device = "/dev/sda";

  networking.extraHosts = ''
    10.45.16.10 pxdevaks001-b5o4ylsd.999bd9f0-b7c7-4e9f-af42-467292a14e36.privatelink.westeurope.azmk8s.io
    10.45.16.101 api-runtime-service.projectx-dev.local
  '';

  networking.firewall.interfaces."enp0s8".allowedUDPPorts = [ 5353 ];
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp0s8";
    networkConfig.DHCP = "ipv4";
    networkConfig.MulticastDNS = true;
    linkConfig.Multicast = true;
  };

  users.users.main.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1Z85qIBll8oYuruw6iDKRU5A2wOG70n6Mo1ScL55LN6rPsJkn/IxbMfCHNLquA/K6cWdL7zh5t8oklrk/PL6RXz1brM8i53hpCOMJ5W3vQ7qbGo+i8zczUAdF+0C1kOIDCdCovNthMKcqpGGy+TNqQyxcLC0L0WNzHiNw04OwLJ7054ufThzwE7jFq0nDQDxX/J7PPZd5S1knKWv//zUNIMXDb2VhWKPV9iEcreep0W170NWyUVICR3P/6QhZNDAKO/srnnSAz8EYyixGKPPe8INrNxo1Woy/k9s4VRjrTZESaTLcT59gR6m8NFPNofATnzJIGu1QwFKF1hrgb1EN2ryy8Vetpsq+kKdtVEwEn7U7fvLqRmQkQDiC1KmXTZlLyvaTzKp/zYhsRIl4M9++YJDuLhx30KliknNGHDm7xWX+BaBvMSW08yw7jkyZkaZzRP2Nfok0U4JMk0Yx5ZB92/ivZqwF3admw6QmayMTu5197AQnuUFzXw7Zj5TsReU= synapse\pavlo.yeremenko@LWO1-LHP-A17665"
  ];

  networking.firewall.interfaces."enp0s8".allowedTCPPorts = [ 2375 ];
}
