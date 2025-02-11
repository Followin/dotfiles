# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, config, pkgs, lib, username, pkgs-unstable, ... }:

{
  hardware.firmware = with pkgs; [ wireless-regdb ];
  boot.extraModprobeConfig = ''
    options libata.force=noncq
  '';

  # boot.consoleLogLevel = 7;

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  services.automatic-timezoned.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true; # use xkbOptions in tty.
  };

  hardware.graphics = {
    enable = true;
  };

  # # Enable the X11 windowing system.
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
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

    xkb = {
      layout = "us,ru,ua";
      options = "ctrl:nocaps,grp:caps_shift_toggle,grp:shift_caps_toggle";
    };
  };

  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin = {
      enable = true;
      user = username;
    };
  };

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
      additionalOptions = ''
        Option "ScrollPixelDistance" "100"
      '';
    };
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  virtualisation.docker = {
    enable = true;
    # extraOptions = "-H tcp://0.0.0.0:2375";
    daemon.settings = {
      hosts = [
        "tcp://0.0.0.0:2375"
      ];
      userland-proxy = false;
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #resolved
  networking.useNetworkd = true;

  services.resolved = {
    enable = true;
    extraConfig = ''
      MulticastDNS=true
    '';
  };

  # Enable sound.
  # sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."10-no-bell" = {
      "context.properties" = {
        "module.x11.bell" = false;
      };
    };
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.


  nixpkgs.config.allowUnfree = true;
  programs.command-not-found.enable = false;
  #programs.steam.enable = true;
  programs.wireshark.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "input" "autologin" "touch" "docker" "wireshark" "vboxsf" ]; 
    hashedPassword = "$y$j9T$cXLG2.zqf1PU62Wf/FC6h1$LtmF6y25m5e.uQ9Y7rCI7veaCU.pQ5bE/KxXdCSFcS0";
  };

  programs.fish.enable = true;
  documentation.man.generateCaches = lib.mkForce false;
  users.defaultUserShell = pkgs.fish;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs-unstable;
    [
      neovim

      iw
      wget
      curl
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
      xdotool
      tldr
      lsof
      neofetch
      file
      dig
      tcpdump

      nasm
      xxd
      hexyl

      cmake
      gnumake

      # audio
      pamixer
      pulseaudio
      alsa-utils
    ];
  programs.nix-ld.enable = true;

  environment.variables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    FZF_CTRL_T_COMMAND = "fd --type f --hidden --follow --exclude .git --exclude node_modules";
    XDG_DATA_HOME = "$HOME/.local/share";
  };

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme = true
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme = true
    '';
  };

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
  # networking.firewall.allowedUDPPorts = [ 5353 ];
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
}

