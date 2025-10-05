{ pkgs, pkgs-unstable, inputs, ... }:

let
  dotnetPkg = (with pkgs-unstable.dotnetCorePackages; combinePackages [
    sdk_8_0
    # sdk_9_0
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
      copilot = {
        enabled = false;
      };
    };
    lsp = {
      ts = {
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
        serverPath = "${pkgs-unstable.buf}/bin/bufls";
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
          enabled = ${pkgs.lib.boolToString nvim.plugins.comment.enabled};
        },
        copilot = {
          enabled = ${pkgs.lib.boolToString nvim.plugins.copilot.enabled};
        }
      },
      lsp = {
        ts = {
          enabled = ${pkgs.lib.boolToString nvim.lsp.ts.enabled};
          serverPath = "${nvim.lsp.ts.serverPath}";
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
        zls = {
          enabled = true;
          serverPath = "${pkgs-unstable.zls}/bin/zls";
        };
        hls = {
          enabled = true;
          serverPath = "${pkgs-unstable.haskell-language-server}/bin/haskell-language-server-wrapper"
        };
        helmls = {
          enabled = true;
          serverPath = "${pkgs-unstable.helm-ls}/bin/helm_ls";
          yamlServerPath = "${pkgs-unstable.yaml-language-server}/bin/yaml-language-server";
        };
      }
    }
  '';

  home.file.".config/gitui/key_bindings.ron".text = ''
    (
      open_help: Some(( code: F(1), modifiers: "")),

      move_left: Some(( code: Char('h'), modifiers: "")),
      move_right: Some(( code: Char('l'), modifiers: "")),
      move_up: Some(( code: Char('k'), modifiers: "")),
      move_down: Some(( code: Char('j'), modifiers: "")),
      
      popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
      popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
      page_up: Some(( code: Char('b'), modifiers: "CONTROL")),
      page_down: Some(( code: Char('f'), modifiers: "CONTROL")),
      home: Some(( code: Char('g'), modifiers: "")),
      end: Some(( code: Char('G'), modifiers: "SHIFT")),
      shift_up: Some(( code: Char('K'), modifiers: "SHIFT")),
      shift_down: Some(( code: Char('J'), modifiers: "SHIFT")),

      edit_file: Some(( code: Char('I'), modifiers: "SHIFT")),

      status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),

      diff_reset_lines: Some(( code: Char('u'), modifiers: "")),
      diff_stage_lines: Some(( code: Char('s'), modifiers: "")),

      stashing_save: Some(( code: Char('w'), modifiers: "")),
      stashing_toggle_index: Some(( code: Char('m'), modifiers: "")),

      stash_open: Some(( code: Char('l'), modifiers: "")),

      abort_merge: Some(( code: Char('M'), modifiers: "SHIFT")),
    )
  '';

  home.file.".config/i3".source = ./home/.config/i3;
  home.file.".config/i3blocks".source = ./home/.config/i3blocks;

  home.file.".config/kitty".source = ./home/.config/kitty;

  home.file.".config/libinput-gestures.conf".source = ./home/.config/libinput-gestures.conf;

  home.file."background.png".source = ./background.png;

  home.file.".ideavimrc".source = ./home/.ideavimrc;

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs-unstable;
    nixpkgs.from = { type = "indirect"; id = "nixpkgs"; };
  };

  programs.git = {
    enable = true;
    # diff-so-fancy = {
    #   enable = true;
    #   changeHunkIndicators = true;
    # };
    difftastic = {
      enable = true;
      background = "dark";
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
          tag = {
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
      nodejs_22
      dotnetPkg
      luajitPackages.luarocks
      nodePackages.fixjson
      prettierd
      nixpkgs-fmt
      ripgrep
      netcoredbg
      p7zip
      powershell
      csharprepl
      zig
      haskell-language-server
      ghc

      docker-compose

      jetbrains.rider
      # jetbrains.datagrip

      google-chrome

      oha
      jq
      wireshark
      openssl
      openvpn

      pkgs.azure-cli
      kubectl
      k9s
      kubernetes-helm
      pkgs.minikube
      gitui

      feh

      pkgs.shutter

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
