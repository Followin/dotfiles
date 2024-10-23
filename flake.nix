{
  description = "PY nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    py-wireguard = {
      url = "github:followin/py-nixos-wireguard";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, py-wireguard, rust-overlay, nixpkgs-unstable, ... }@inputs:
    let
      username = "main";
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      specialArgs = { inherit inputs username pkgs-unstable; };
      sharedModules = [
        py-wireguard.nixosModules.default
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username}.imports = [ ./home.nix ];
        }

        # rust
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ rust-overlay.overlays.default ];
          home-manager.users.${username}.home.packages = [
            (pkgs.rust-bin.nightly.latest.default.override {
              extensions = [ "rust-src" "rust-analyzer" "clippy" ];
            })
          ];
        })
      ];
      nixosModules = [
        ./machines/nixos/configuration.nix
        {
          home-manager.users.${username}.imports = [ ./machines/nixos/home.nix ];
        }
      ];

      nixvmModules = [
        ./machines/nixvm/configuration.nix
        {
          home-manager.users.${username}.imports = [ ./machines/nixvm/home.nix ];
        }
      ];
    in
    {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem rec {
          inherit system specialArgs;
          modules = sharedModules ++ nixosModules;
        };

        "nixvm" = nixpkgs.lib.nixosSystem rec {
          inherit system specialArgs;
          modules = sharedModules ++ nixvmModules;
        };
      };
    };
}
