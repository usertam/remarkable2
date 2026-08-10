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
        in
        {
          userland = pkgs.callPackage ./pkgs/userland/package.nix {
            inherit remarkablePkgs;
            cmds = import ./cmds.nix;
            services = ./pkgs/systemd-services;
          };

          kernel =
            let
              inherit (remarkablePkgs.linuxPackages) kernel;
            in
            pkgs.runCommand "remarkable2-kernel" { } ''
              mkdir -p $out

              cp -r ${kernel.out}/. $out
              cp -r ${kernel.modules}/. $out

              # `modules` ships lib/modules/<ver>/source as a dangling symlink into the
              # build sandbox (/build/source); it collides with dev's real source tree.
              # Drop broken symlinks so dev's real source/build dirs merge in cleanly.
              chmod +w $out/lib/modules/*
              rm -f $out/lib/modules/*/source

              cp -r ${kernel.dev}/. $out
            '';

          archive = nixpkgs.lib.genAttrs [ "userland" "kernel" ] (
            name:
            let
              src = self.packages.${system}.${name};
            in
            pkgs.runCommand "${src.name}-archive"
              {
                inherit src;
                nativeBuildInputs = with pkgs; [
                  gnutar
                  pixz
                ];
              }
              ''
                mkdir -p $out/tarball
                time tar --sort=name --mtime='@1' --owner=0 --group=0 --numeric-owner -C $src -c . | \
                  pixz -9 > $out/tarball/${src.name}-${stamp}.tar.xz
              ''
          );

          default = self.packages.${system}.userland;
        }
      );
    };
}
