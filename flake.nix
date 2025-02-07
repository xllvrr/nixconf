{
    description = "Nixos Config Flake";

    inputs = {

        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        hyprland.url = "github:hyprwm/Hyprland?submodules=1";
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };

        stylix.url = "github:danth/stylix";

        nvf.url = "github:notashelf/nvf";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    };

    outputs = { self, nixpkgs, home-manager, nvf, hyprland, ... }@inputs:

        let

            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            customNvim = nvf.lib.neovimConfiguration {
                inherit pkgs;
                modules = [ standalones/nvf.nix ];
            };

        in {

            packages.${system}.my-neovim = customNvim.neovim;

            nixosConfigurations.NixDesktop = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/NixDesktop/configuration.nix
                    inputs.stylix.nixosModules.stylix
                    inputs.home-manager.nixosModules.default
                    {environment.systemPackages = [customNvim.neovim];}
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.xllvr = import ./hosts/NixDesktop/home.nix;
                    }
                ];
            };
        };

}
