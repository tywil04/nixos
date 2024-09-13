{ nixosVersion, diskPath }: {
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-${nixosVersion}";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko }: {
    nixosModules.diskoConfiguration = { config, pkgs, ... }: {
      disko.enable = true;
      disko.config = disko.lib.mkDiskoCfg {
        devices = {
          "${diskPath}" = {
            type = "disk";
            partitions = {
              boot = {
                type = "esp";
                size = "500MiB";
              };
              root = {
                type = "luks";
                device = "/dev/mapper/root";
                size = "max";
              };
            };
          };
        };
        lvm.enable = true;
        lvm.config = {
          "/dev/mapper/root" = {
            name = "root";
            type = "btrfs";
            size = "max";
          };
          "/dev/mapper/swap" = {
            name = "swap";
            type = "swap";
            size = "18GiB";
          };
        };
        bootLoader = {
          type = "grub2";
          grub2 = {
            device = diskPath;
            efi.canTouchEfiVariables = true;
          };
        };
        filesystems = {
          "/" = {
            device = "/dev/mapper/root";
            fsType = "btrfs";
          };
          "swap" = {
            device = "/dev/mapper/swap";
            fsType = "swap";
          };
        };
      };
    };
  };
}
