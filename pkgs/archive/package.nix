{
  runCommand,
  gnutar,
  pixz,
  stamp,
}:

src:
runCommand "${src.name}-archive"
  {
    inherit src;
    nativeBuildInputs = [
      gnutar
      pixz
    ];
  }
  ''
    mkdir -p $out/tarball
    time tar --sort=name --mtime='@1' --owner=0 --group=0 --numeric-owner -C $src -c . | \
      pixz -9 > $out/tarball/${src.name}-${stamp}.tar.xz
  ''
