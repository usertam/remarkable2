{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      overlay = import ./overlay.nix;

      # Stamp archives with the commit date and short hash, e.g. "20250329.eb0e0f2".
      # Falls back to a dirty/zeroed rev when the tree isn't committed.
      stamp = "${builtins.substring 0 8 self.lastModifiedDate}.${
        builtins.substring 0 7 (self.rev or self.dirtyRev or "0000000")
      }";
    in
    {
      overlays.default = overlay;

      # Overlaid cross set, exposed for building/debugging individual cross packages
      # e.g. `nix build .#legacyPackages.aarch64-linux.socat`
      legacyPackages = forAllSystems (
        system: nixpkgs.legacyPackages.${system}.pkgsCross.remarkable2.pkgsStatic.extend overlay
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          remarkablePkgs = self.legacyPackages.${system};

          userland = pkgs.callPackage ./pkgs/userland/package.nix {
            inherit remarkablePkgs;
            cmds = import ./cmds.nix;
            services = ./pkgs/systemd-services;
          };
          kernel = pkgs.callPackage ./pkgs/kernel/package.nix { inherit remarkablePkgs; };
          mkArchive = pkgs.callPackage ./pkgs/archive/package.nix { inherit stamp; };
        in
        {
          inherit userland kernel;
          archive = {
            userland = mkArchive userland;
            kernel = mkArchive kernel;
          };
          default = userland;
        }
      );
    };
}
