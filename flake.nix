{
  description = "Neovide flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ ( final: prev: { neovide = (prev.callPackage ./default.nix) { }; } ) ];
          inherit system;
        };
      in
      {

        packages = flake-utils.lib.flattenTree  {
          neovide = pkgs.neovide;
        };

        defaultPackage = pkgs.neovide;
      }
    );
}
