{
  description = "Nixos Config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    stylix,
    home-manager,
    nvf,
    ...
  } @ inputs: let
    unfree = [
      "steam"
      "steam-unwrapped"
    ];

    system = "x86_64-linux";
    allowUnfreePredicate = pkg:
      builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree;

    mkPkgs = nixpkgsInput:
      import nixpkgsInput {
        inherit system;
        config.allowUnfreePredicate = allowUnfreePredicate;
      };

    pkgs = mkPkgs nixpkgs;
    pkgsUnstable = mkPkgs nixpkgs-unstable;

    customNvim = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [standalones/nvf/nvf.nix];
    };
  in {
    packages.${system}.my-neovim = customNvim.neovim;

    nixosConfigurations.NixDesktop = nixpkgs.lib.nixosSystem {
      pkgs = pkgs;
      specialArgs = {inherit inputs pkgsUnstable;};
      modules = [
        ./hosts/NixDesktop/configuration.nix
        stylix.nixosModules.stylix
        {
          environment.systemPackages = [
            customNvim.neovim
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = {inherit inputs pkgsUnstable;};
          home-manager.users.xllvr = import ./hosts/NixDesktop/home.nix;
        }
      ];
    };
  };
}
