# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, config, pkgs, ... }:

let
  dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_6_0
    sdk_7_0
    sdk_8_0
  ]);
in
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

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
    ];
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "JetBrainsMono Nerd Font";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # # Enable the X11 windowing system.
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "main";
      };
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };

    libinput.enable = true; # touchpad
    libinput.touchpad.naturalScrolling = true;
    libinput.touchpad.disableWhileTyping = true;
    libinput.touchpad.additionalOptions = ''
      Option "ScrollPixelDistance" "50"
    '';

    layout = "us,ru";
    xkbOptions = "ctrl:nocaps,grp:caps_shift_toggle,grp:shift_caps_toggle";
  };

  security.polkit.enable = true;

  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.


  nixpkgs.config.allowUnfree = true;
  programs.command-not-found.enable = false;
  programs.fish.enable = true;
  users.users.main = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "input" "autologin" "touch" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
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
    ];
  };
  users.defaultUserShell = pkgs.fish;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  networking.wireless = {
    enable = true;
    networks = {
      "21" = {
        psk = "testjkl123";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    networkmanager
    pavucontrol
    git
    kitty
    fzf
    bat
    fd
    unzip
    binutils
    gcc
    glibc
    sysstat
    acpi
    btop
    xclip
    libinput-gestures
    tldr

    fishPlugins.z
    fishPlugins.fzf-fish
    fishPlugins.pure
  ];

  environment.variables = rec {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    FZF_CTRL_T_COMMAND = "fd --type f --hidden --follow --exclude .git --exclude node_modules";
    DOTNET_ROOT = "${dotnetPkg}";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-23.05";
  };
}

