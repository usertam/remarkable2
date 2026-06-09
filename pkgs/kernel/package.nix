{
  runCommand,
  remarkablePkgs,
}:

with remarkablePkgs.linuxPackages;
runCommand "remarkable2-kernel" { } ''
  mkdir -p $out

  cp -r ${kernel.out}/. $out
  cp -r ${kernel.modules}/. $out

  # `modules` ships lib/modules/<ver>/source as a dangling symlink into the
  # build sandbox (/build/source); it collides with dev's real source tree.
  # Drop broken symlinks so dev's real source/build dirs merge in cleanly.
  chmod +w $out/lib/modules/*
  rm -f $out/lib/modules/*/source

  cp -r ${kernel.dev}/. $out
''
