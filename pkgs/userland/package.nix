{
  lib,
  runCommand,
  remarkablePkgs,
  cmds,
  services,
}:

let
  drvMap = lib.mapAttrs' (
    drvName: binList:
    let
      # Process names with dots in them, e.g. "util-linux.mount" -> pkgs.util-linux.mount
      path = lib.splitString "." drvName;
      drv = lib.getAttrFromPath path remarkablePkgs;
      # Format the binary list in bash brace expansion format.
      wrapIfMulti = lib.optionalString (builtins.length binList > 1);
      drvBins = (wrapIfMulti "{") + (builtins.concatStringsSep "," binList) + (wrapIfMulti "}");
    in
    lib.nameValuePair drvName {
      inherit drv drvBins;
    }
  ) cmds;
in
runCommand "remarkable2-userland"
  {
    srcs = lib.mapAttrsToList (_: v: v.drv) drvMap;
  }
  ''
    mkdir -p $out/bin
    cp -at $out/bin \
      ${lib.concatMapAttrsStringSep " \\\n  " (
        _: v: "${v.drv}/bin/${v.drvBins}"
      ) drvMap}

    # Replace the wrapped tailscaled with a non-wrapped one
    rm -f $out/bin/tailscaled
    mv $out/bin/.tailscaled-wrapped $out/bin/tailscaled

    # Ship the custom systemd units
    mkdir -p $out/etc/systemd/system
    cp -a ${services}/*.service $out/etc/systemd/system/
  ''
