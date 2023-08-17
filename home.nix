{ config, pkgs, ... }:

let
  dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_6_0
    sdk_7_0
    sdk_8_0
  ]);
in
{
  home.username = "main";
  home.homeDirectory = "/home/main";

  home.stateVersion = "23.05";

  home.file.".tmux.conf".source = ./home/.tmux.conf;

  home.file.".config/fish/user".source = ./home/.config/fish/user;

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

  home.file."background.png".source = ./background.png;

  programs.git = {
    enable = true;
    userName = "followin";
    userEmail = "dlike.version10@gmail.com";
  };

  programs.fish =
    {
      enable = true;
      interactiveShellInit = ''
        for f in $HOME/.config/fish/user/**/*.fish
          source $f
        end
      '';
      plugins = with pkgs.fishPlugins; [
        { name = "z"; src = z.src; }
        { name = "fzf-fish"; src = fzf-fish.src; }
        { name = "pure"; src = pure.src; }
      ];
    };

  home.packages = with pkgs;
    [
      nodejs_20

      dotnetPkg

      rustup

      luajitPackages.luarocks

      nodePackages.eslint

      jetbrains.rider

      google-chrome
      discord
      telegram-desktop
      zoom-us

      feh

      shutter

      protontricks
    ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnetPkg}";
  };


  programs.home-manager.enable = true;
}
