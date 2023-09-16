{
  description = "PY nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, home-manager, py-wireguard, rust-overlay, ... }@inputs:
    let
      username = "main";
    in
    {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
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
        };
      };
    };
}
