# System flake for reMarkable 2

A Nix flake that cross-compiles a static userland and a custom kernel for the reMarkable 2, packaged as `.tar.xz` archives you
extract on-device. It adds a useful set of CLI tools, Tailscale,
and systemd units that expose the device's Web UI over your tailnet.

Everything is built against `pkgsCross.remarkable2.pkgsStatic`, so binaries are statically
linked and drop straight onto stock firmware without touching the system's libraries.

## Layout

```
flake.nix              Inputs and outputs wiring
overlay.nix            Cross overlay: package tweaks + custom kernel + getent
cmds.nix               Map of package -> binaries to include in the userland
pkgs/
  userland/            Assembles the userland tree (binaries + systemd units)
  kernel/              Merges the kernel image, headers, and modules into one tree
  archive/             Wraps a derivation into a reproducible .tar.xz
  remarkable2-kernel/  The reMarkable 5.4.70 kernel build (+ patches)
  alpine-musl-getent/  A musl getent shim (musl ships none)
  systemd-services/    Units shipped into the userland tarball
.github/workflows/
  build.yml            Builds and uploads the two archives on push/PR
  staging.yml          Weekly `nix flake update` PR
```

## Outputs

```
packages.<system>.userland          The userland tree ($out/bin, $out/etc/systemd/system)
packages.<system>.kernel            The combined kernel tree (image + dev + modules)
packages.<system>.archive.userland  -> remarkable2-userland-<date>.<rev>.tar.xz
packages.<system>.archive.kernel    -> remarkable2-kernel-<date>.<rev>.tar.xz
legacyPackages.<system>             The overlaid cross set, for single packages
overlays.default                    The cross overlay, reusable elsewhere
```

`<system>` is the *build* platform (`x86_64-linux` or `aarch64-linux`); the artifacts are
always armv7l static binaries for the device.

## Building

These derivations build on Linux. On other hosts use a remote/Linux builder.

```sh
# The deliverables
nix build .#packages.aarch64-linux.archive.userland
nix build .#packages.aarch64-linux.archive.kernel
# -> result/tarball/remarkable2-{userland,kernel}-<date>.<rev>.tar.xz

# Intermediates, handy while iterating
nix build .#packages.aarch64-linux.userland
nix build .#packages.aarch64-linux.kernel

# Build a single cross package via the exposed cross set
nix build .#legacyPackages.aarch64-linux.socat
```

CI builds both archives on `ubuntu-22.04-arm` and uploads
them as workflow artifacts.

## Customizing the userland

Edit `cmds.nix`. Keys are package names in the cross set; values are the binaries to copy
out of `${pkg}/bin`. Dotted keys index nested attributes e.g. `"util-linux.mount"` resolves
to `pkgs.util-linux.mount`. To pull in a package that needs a tweak, override it in
`overlay.nix` first, then list it in `cmds.nix`.
