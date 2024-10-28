{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    nixpkgs,
    self,
    systems,
    ...
  }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    # Package the app
    packages = forEachSystem (system: let
      callPackage = nixpkgs.darwin.apple_sdk_11_0.callPackage or nixpkgs.legacyPackages.${system}.callPackage;
    in {
      default = callPackage ./. {};
    });

    overlays.default = final: prev: {
      tailwindcss = self.packages.${final.system}.default;
    };
  };
}
