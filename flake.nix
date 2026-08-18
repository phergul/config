{
  description = "config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus.url = "github:dj95/zjstatus";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, zjstatus, ... }:
    let
      lib = nixpkgs.lib;
      userName = let value = builtins.getEnv "USER"; in if value == "" then "fergal" else value;
      homeDirectory = system:
        if builtins.match ".*-darwin" system != null
        then "/Users/${userName}"
        else "/home/${userName}";

      makePkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      homeModule = system: {
        home.username = userName;
        home.homeDirectory = homeDirectory system;
        home.stateVersion = "24.11";
        home.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
        imports = [ ./home ];
      };

      linuxHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = makePkgs system;
        extraSpecialArgs = { inherit zjstatus; };
        modules = [ (homeModule system) ./hosts/linux.nix ];
      };

      darwinConfig = system: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit self; };
        modules = [
          ./darwin
          ./hosts/macos.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.backupCommand = "${self}/scripts/home-manager-backup";
            home-manager.users.${userName} = homeModule system // {
              imports = [ ./home ./home/macos.nix ];
            };
            home-manager.extraSpecialArgs = { inherit self zjstatus; };
          }
        ];
      };
    in {
      homeConfigurations = {
        linux = linuxHome "x86_64-linux";
        linux-aarch64 = linuxHome "aarch64-linux";
      };

      darwinConfigurations = {
        macos = darwinConfig "aarch64-darwin";
        macos-intel = darwinConfig "x86_64-darwin";
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;
    };
}
