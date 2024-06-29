{ pkgs, pkgs-unstable, ... }:

let
  dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_6_0
    sdk_7_0
    sdk_8_0
  ]);
  omnisharp =
    (pkgs-unstable.writeShellScriptBin "omnisharp" ''
      ${dotnetPkg}/bin/dotnet ${pkgs-unstable.omnisharp-roslyn}/lib/omnisharp-roslyn/OmniSharp.dll "$@"
    '');
  nvim = {
    plugins = {
      comment = {
        enabled = true;
      };
    };
    lsp = {
      tsserver = {
        enabled = true;
        serverPath = "${pkgs-unstable.nodePackages.typescript-language-server}/bin/typescript-language-server";
      };
      omnisharp = {
        enabled = true;
        serverPath = "${omnisharp}/bin/omnisharp";
      };
      lua_ls = {
        enabled = true;
        serverPath = "${pkgs-unstable.lua-language-server}/bin/lua-language-server";
      };
      nixd = {
        enabled = true;
        serverPath = "${pkgs-unstable.nixd}/bin/nixd";
      };
      jsonls = {
        enabled = true;
        serverPath = "${pkgs-unstable.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver";
      };
      bufls = {
        enabled = true;
        serverPath = "${pkgs-unstable.buf-language-server}/bin/bufls";
      };
      efm = {
        enabled = true;
        serverPath = "${pkgs-unstable.efm-langserver}/bin/efm-langserver";
        prettierdPath = "${pkgs-unstable.prettierd}/bin/prettierd";
        fixJsonPath = "${pkgs-unstable.nodePackages.fixjson}/bin/fixjson";
      };
    };
  };
in
{
  home.username = "main";
  home.homeDirectory = "/home/main";

  home.stateVersion = "23.05";

  home.file.".tmux.conf".source = ./home/.tmux.conf;

  home.file.".config/fish/user".source = ./home/.config/fish/user;

  home.file.".config/nvim" = {
    source = ./home/.config/nvim;
    recursive = true;
  };

  home.file.".config/nvim/lua/config.lua".text = ''
    vim.g.nixConfig = {
      plugins = {
        comment = {
          enabled = ${if nvim.plugins.comment.enabled then "true" else "false"};
        },
      },
      lsp = {
        tsserver = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.tsserver.enabled};
          serverPath = "${nvim.lsp.tsserver.serverPath}";
        };
        omnisharp = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.omnisharp.enabled};
          serverPath = "${nvim.lsp.omnisharp.serverPath}";
        };
        lua_ls = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.lua_ls.enabled};
          serverPath = "${nvim.lsp.lua_ls.serverPath}";
        };
        nixd = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.nixd.enabled};
          serverPath = "${nvim.lsp.nixd.serverPath}";
        };
        jsonls = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.jsonls.enabled};
          serverPath = "${nvim.lsp.jsonls.serverPath}";
        };
        bufls = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.bufls.enabled};
          serverPath = "${nvim.lsp.bufls.serverPath}";
        };
        efm = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.efm.enabled};
          serverPath = "${nvim.lsp.efm.serverPath}";
          prettierdPath = "${nvim.lsp.efm.prettierdPath}";
          fixJsonPath = "${nvim.lsp.efm.fixJsonPath}";
        };
      }
    }
  '';

  home.file.".config/i3".source = ./home/.config/i3;
  home.file.".config/i3blocks".source = ./home/.config/i3blocks;

  home.file.".config/kitty".source = ./home/.config/kitty;

  home.file.".config/libinput-gestures.conf".source = ./home/.config/libinput-gestures.conf;

  home.file."background.png".source = ./background.png;

  home.file.".ideavimrc".source = ./home/.ideavimrc;

  programs.git = {
    enable = true;
    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = true;
    };
    extraConfig = {
      rerere.enable = true;
      rebase.updateRefs = true;
    };
    includes = [
      {
        condition = "hasconfig:remote.*.url:*github.com*/**";
        contents = {
          user = {
            email = "dlike.version10@gmail.com";
            name = "Followin";
            signingKey = "~/.ssh/github";
          };
          gpg = {
            format = "ssh";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
  };

  programs.fish =
    {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings

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

  home.packages = with pkgs-unstable;
    [
      neovide

      # neovim lsps and plugins
      nodejs_20
      dotnetPkg
      luajitPackages.luarocks
      nodePackages.fixjson
      prettierd
      nixpkgs-fmt
      ripgrep
      netcoredbg
      p7zip
      powershell

      docker-compose

      jetbrains.rider
      jetbrains.datagrip

      kubectl
      azure-cli

      google-chrome
      discord
      telegram-desktop
      zoom-us
      teams-for-linux
      xcompmgr

      jq
      wireshark
      openssl
      openvpn

      kubectl
      kubernetes-helm
      minikube

      feh

      shutter

      xfce.thunar

      # steam
      # protontricks
      # (writeShellScriptBin "steam-offloaded" ''
      #   nvidia-offload steam
      # '')
    ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnetPkg}";
  };

  # TODO: Make derivation out of this
  home.sessionPath = [
    "/home/main/@data/pulum/pulumi-dotnet/pulumi-language-dotnet"
  ];

  programs.home-manager.enable = true;
}
