let
  nixosVersion = "24.04";
  diskPath = "/dev/vda";
in 
{
  inputs = {
    disko-configuration.url = "path:./disko-configuration";
    configuration.url = "path:./configuration";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-${nixosVersion}";
  };

  outputs = { self, nixpkgs, disko-configuration, configuration }: {
    nixosConfigurations = {
      image = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (disko-configuration { nixosVersion = nixosVersion; diskPath = diskPath; })
          (configuration { nixosVersion = nixosVersion; })
        ];
      };
    };
  };
}