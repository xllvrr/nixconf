{
  description = "Nixos Config Flake";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    hyprland.url = "github:hyprwm/Hyprland";

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

  outputs = { self, nixpkgs, home-manager, nvf, ... }@inputs:

    let
    
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    
    in {

      packages.system.default =
      (nvf.lib.neovimConfiguration { modules = [ standalones/nvf.nix ]; }).neovim;
      
      nixosConfigurations.NixDesktop = nixpkgs.lib.nixosSystem {
	specialArgs = { inherit inputs; };
	modules = [
	    ./hosts/NixDesktop/configuration.nix
	    inputs.stylix.nixosModules.stylix
	    inputs.home-manager.nixosModules.default
	];
      };

      homeConfigurations.NixDesktop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	extraSpecialArgs = { inherit inputs; };
	modules = [ 
	    ./hosts/NixDesktop/home.nix 
	];
      };

    };

}
