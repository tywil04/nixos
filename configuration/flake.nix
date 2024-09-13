{ nixosVersion }: {
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-${nixosVersion}";
    home-manager.url = "github:nix-community/home-manager/release-${nixosVersion}";
  };

  outputs = { self, nixpkgs }: {
    nixosModules.configuration = { config, pkgs, ... }: {
    networking.hostName = "nixos";
      system.stateVersion = nixosVersion;

      services.xserver = {
        enable = true;
        displayManager.gdm = {
          enable = true;
          wayland = true;
        };
        desktopManager.gnome.enable = true;
      };

      users.users.tyler = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        password = "password";
      };

      security.sudo.enable = true;

      home-manager.useUserPackages = true;
      home-manager.users.tyler = { pkgs, ... }: {
        home = {
          stateVersion = nixosVersion;
          packages = [
            pkgs.gnome3.gnome-tweaks
          ];
        };
        dconf = {
          enable = true;
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
      };

      networking.firewall.enable = true;
    };
  };
}
