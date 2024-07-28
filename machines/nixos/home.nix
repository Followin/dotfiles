{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    discord
    telegram-desktop
    zoom-us
    teams-for-linux
    xcompmgr
  ];
}
