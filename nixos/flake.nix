{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Add grub2 themes to your inputs ...
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, grub2-themes, home-manager, ... }: {
    nixosConfigurations = {
      watt-the-hell = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        # ... and then to your modules
        modules = [
          ./configuration.nix
          grub2-themes.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
