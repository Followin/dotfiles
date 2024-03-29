{
  description = "PY nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = { self, nixpkgs, home-manager, py-wireguard, rust-overlay, nixpkgs-stable, ... }@inputs:
    let
      username = "main";
      system = "x86_64-linux";
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      specialArgs = { inherit inputs pkgs-stable; };
      sharedModules = [
        py-wireguard.nixosModules.default
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username}.imports = [ ./home.nix ];
          home-manager.extraSpecialArgs = specialArgs;
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
    in
    {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem rec {
          inherit system specialArgs;
          modules = sharedModules ++ [ ./machines/nixos/configuration.nix ];
        };

        "nixvm" = nixpkgs.lib.nixosSystem rec {
          inherit system specialArgs;
          modules = sharedModules ++ [ ./machines/nixvm/configuration.nix ];
        };
      };
    };
}
