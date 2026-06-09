final: prev: {
  iproute2 = prev.iproute2.override { python3 = null; };
  socat = prev.socat.overrideAttrs (prev: { hardeningEnable = [ ]; });
  linuxPackages = prev.callPackage ./pkgs/remarkable2-kernel/package.nix { };
  alpine-musl-getent = prev.callPackage ./pkgs/alpine-musl-getent/package.nix { };
}
