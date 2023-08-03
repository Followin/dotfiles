{ config, pkgs, ... }:

{
  home.username = "main";
  home.homeDirectory = "/home/main";

  home.stateVersion = "23.05";

  home.file.".tmux.conf".source = ./home/.tmux.conf;

  home.file.".config/fish/user" = {
    source = ./home/.config/fish/user;
    recursive = true;
  };
  home.file.".config/fish/config.fish".source = ./home/.config/fish/config.fish;

  home.file.".config/nvim/lua/user/init.lua".source = ./home/.config/nvim.lua;

  home.file.".config/i3/config".source = ./home/.config/i3config;
  home.file.".config/i3blocks" = {
    source = ./home/.config/i3blocks;
    recursive = true;
  };

  home.file.".config/libinput-gestures.conf".source = ./home/.config/libinput-gestures.conf;


  programs.git = {
    enable = true;
    userName = "followin";
    userEmail = "dlike.version10@gmail.com";
  };

  programs.home-manager.enable = true;
}
