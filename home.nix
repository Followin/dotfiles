{ config, pkgs, ... }:

{
  home.username = "main";
  home.homeDirectory = "/home/main";

  home.stateVersion = "23.05";

  home.file.".tmux.conf".source = ./home/.tmux.conf;

  home.file.".config/fish/user".source = ./home/.config/fish/user;
  home.file.".config/fish/config.fish".source = ./home/.config/fish/config.fish;

  home.file.".config/nvim".source = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "v3.34.5";
    sha256 = "4RqZVEWTWoZYDsV/JcBQ+Z0ISyu4HbFwl0N715bFSP8=";
  };
  home.file.".config/astronvim/lua/user/init.lua".source = ./home/.config/nvim.lua;

  home.file.".config/i3".source = ./home/.config/i3;
  home.file.".config/i3blocks".source = ./home/.config/i3blocks;


  home.file.".config/kitty".source = ./home/.config/kitty;

  home.file.".config/libinput-gestures.conf".source = ./home/.config/libinput-gestures.conf;


  programs.git = {
    enable = true;
    userName = "followin";
    userEmail = "dlike.version10@gmail.com";
  };

  programs.home-manager.enable = true;
}
