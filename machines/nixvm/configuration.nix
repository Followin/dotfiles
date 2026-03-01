{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.checkJournalingFS = false;

  networking.extraHosts = ''
  '';

  networking.firewall.interfaces."enp0s3".allowedUDPPorts = [ 5353 ];
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp0s3";
    networkConfig.DHCP = "ipv4";
    networkConfig.MulticastDNS = true;
    linkConfig.Multicast = true;
  };

  users.users.main.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1Z85qIBll8oYuruw6iDKRU5A2wOG70n6Mo1ScL55LN6rPsJkn/IxbMfCHNLquA/K6cWdL7zh5t8oklrk/PL6RXz1brM8i53hpCOMJ5W3vQ7qbGo+i8zczUAdF+0C1kOIDCdCovNthMKcqpGGy+TNqQyxcLC0L0WNzHiNw04OwLJ7054ufThzwE7jFq0nDQDxX/J7PPZd5S1knKWv//zUNIMXDb2VhWKPV9iEcreep0W170NWyUVICR3P/6QhZNDAKO/srnnSAz8EYyixGKPPe8INrNxo1Woy/k9s4VRjrTZESaTLcT59gR6m8NFPNofATnzJIGu1QwFKF1hrgb1EN2ryy8Vetpsq+kKdtVEwEn7U7fvLqRmQkQDiC1KmXTZlLyvaTzKp/zYhsRIl4M9++YJDuLhx30KliknNGHDm7xWX+BaBvMSW08yw7jkyZkaZzRP2Nfok0U4JMk0Yx5ZB92/ivZqwF3admw6QmayMTu5197AQnuUFzXw7Zj5TsReU= synapse\pavlo.yeremenko@LWO1-LHP-A17665"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKHO0MG7OxxmC6XtBhhfJLpH2+w1Y307isUURVNmr/Cf luxoft\payeremenko@PAYEREMENKO"
  ];

  networking.firewall.interfaces."enp0s3".allowedTCPPorts = [ 2375 ];

  security.pki.certificates = [
    ''
    -----BEGIN CERTIFICATE-----
    MIIE6DCCA9CgAwIBAgIJANu+mC2Jt3uTMA0GCSqGSIb3DQEBCwUAMIGhMQswCQYD
    VQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTERMA8GA1UEBxMIU2FuIEpvc2Ux
    FTATBgNVBAoTDFpzY2FsZXIgSW5jLjEVMBMGA1UECxMMWnNjYWxlciBJbmMuMRgw
    FgYDVQQDEw9ac2NhbGVyIFJvb3QgQ0ExIjAgBgkqhkiG9w0BCQEWE3N1cHBvcnRA
    enNjYWxlci5jb20wIBcNMjUwMjAyMTYzODIwWhgPMjA1MjA2MjAxNjM4MjBaMIGh
    MQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTERMA8GA1UEBxMIU2Fu
    IEpvc2UxFTATBgNVBAoTDFpzY2FsZXIgSW5jLjEVMBMGA1UECxMMWnNjYWxlciBJ
    bmMuMRgwFgYDVQQDEw9ac2NhbGVyIFJvb3QgQ0ExIjAgBgkqhkiG9w0BCQEWE3N1
    cHBvcnRAenNjYWxlci5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
    AQCpPtJNLFlFOAQUV/p2gdqNJzW+TmObOYzoFa46jTjgSxpNz15URX8eMf/UNbNm
    1yt9OP6eLbTlqkxOUoFbdRhH6XIsdD0WhmINdhcrymgpJXn5ObRWWz/kpvyaSFVW
    q/suBgSa8Rjsc9j6LWcQZkJrjplcI6iEnSYES0H0lWWkMg76c3SFQwBhh1nUplYI
    w1/kn9pNmJKGyis3YDfyJI6F136ZxEziI0veCwu731eEqdGoqgd4fzeVV1+7VcF6
    hDPPlXqADeRtG+EPCgiVMF4xrmXjJF0kB92mRsXOqLBKA12FvFMedhiisPMp+vas
    QUx2wxTQMd14Bl/vXX7UK6e5AgMBAAGjggEdMIIBGTAdBgNVHQ4EFgQUubfdSs3D
    DgyGnV3f7BwEacVOmN8wDwYDVR0TAQH/BAUwAwEB/zCB1gYDVR0jBIHOMIHLgBS5
    t91KzcMODIadXd/sHARpxU6Y36GBp6SBpDCBoTELMAkGA1UEBhMCVVMxEzARBgNV
    BAgTCkNhbGlmb3JuaWExETAPBgNVBAcTCFNhbiBKb3NlMRUwEwYDVQQKEwxac2Nh
    bGVyIEluYy4xFTATBgNVBAsTDFpzY2FsZXIgSW5jLjEYMBYGA1UEAxMPWnNjYWxl
    ciBSb290IENBMSIwIAYJKoZIhvcNAQkBFhNzdXBwb3J0QHpzY2FsZXIuY29tggkA
    276YLYm3e5MwDgYDVR0PAQH/BAQDAgGGMA0GCSqGSIb3DQEBCwUAA4IBAQBZ257u
    6xcDnfq33Dhdi0h/g+5kz5wto+0w1U/y2V3bAfwOzvSiKfrOGEssYNVdv17qSOUC
    jFs/kvCmZnS2ZAr/iAxeD8qkC6Zb5552LRCiV4XHBaeN6Cd+YTJMgVKmBxFrsxlE
    PmauxO1aIwTf3eQmD+n5Yn7MkKClIedkfrwHq4s3ZvyvyplAwjSwyesmEz/5Gdk9
    XdhsfrIlWq8DyJijNGysBOceYOB6jmCijtwFG02ubAfiIMZ/BRC8+O7wjzDgRALz
    OC2+mQytSkKo8K6MskfEdjQGZctKaPISG344PQY/y4zKBf1JNpSfsTBzaI9lj7PK
    m7q2TzMp8s5DuGbK
    -----END CERTIFICATE-----
    ''
  ];

  # networking.firewall.checkReversePath = "loose";
}
