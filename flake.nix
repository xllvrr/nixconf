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

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
    };
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    home-manager,
    nvf,
    hyprland,
    ...
  } @ inputs: let
    unfree = [
      "steam"
      "steam-unwrapped"
    ];

    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = (
        pkg:
          builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree
      );
    };
    customNvim = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [standalones/nvf.nix];
    };
  in {
    packages.${system}.my-neovim = customNvim.neovim;

    nixosConfigurations.NixDesktop = nixpkgs.lib.nixosSystem {
      pkgs = pkgs;
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/NixDesktop/configuration.nix
        stylix.nixosModules.stylix
        {environment.systemPackages = [customNvim.neovim];}
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.users.xllvr = import ./hosts/NixDesktop/home.nix;
          home-manager.sharedModules = [inputs.nixcord.homeModules.nixcord];
        }
      ];
    };
  };
}
