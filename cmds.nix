{
  coreutils = [
    "cp" "mv" "rm" "ln"
    "mkdir" "mkfifo" "mknod" "mktemp"
    "truncate" "touch" "install"
    "basename" "dirname" "realpath"
    "cat" "tac" "head" "tail"
    "split" "cut" "tr" "sort" "uniq" "wc"
    "tee" "fold" "yes"
    "chmod" "chown" "chgrp"
    "md5sum" "sha256sum" "sha512sum"
    "id" "who" "whoami" "logname"
    "uname" "uptime" "tty"
    "nice" "nohup" "timeout"
    "chroot"
    "env" "expr" "factor" "seq"
    "df" "du" "stat" "sync"
    "dircolors"
    "date" "sleep"
    "coreutils"
  ];

  file = [ "file" ];

  findutils = [
    "find" "xargs"
  ];

  util-linux = [
    "fallocate" "fdisk" "losetup" "lsblk"
    "mountpoint"
    "flock" "ionice" "renice" "nsenter" "unshare"
    "setarch" "setpriv" "setsid" "setterm"
    "dmesg" "logger" "last"
    "rfkill" "lscpu" "hwclock"
    "hexdump" "rev" "look" "more"
    "cal" "uuidgen" "getopt" "whereis"
  ];

  "util-linux.mount" = [
    "mount" "umount"
  ];

  which = [ "which" ];

  diffutils = [
    "diff" "cmp"
    "diff3" "sdiff"
  ];

  gnugrep = [
    "grep"
    "egrep" "fgrep"
  ];

  gnused = [ "sed" ];

  gnupatch = [ "patch" ];

  jq = [ "jq" ];

  less = [ "less" ];

  curl = [ "curl" ];

  inetutils = [
    "ping" "ping6" "traceroute"
    "hostname" "whois"
  ];

  rsync = [ "rsync" ];

  # nmap = [
  #   "nmap" "ncat" "nping"
  # ];

  # ndisc6 = [
  #   "ndisc6" "rltraceroute6" "tcptraceroute6" "tracert6"
  #   "tcpspray" "tcpspray6"
  # ];

  btop = [ "btop" ];

  procps = [
    "kill" "pgrep" "pkill" "pidof"
    "ps" "top" "pmap"
    "free" "vmstat" "watch"
    "sysctl"
  ];

  lsof = [ "lsof" ];

  strace = [ "strace" ];

  gnutar = [ "tar" ];

  pigz = [ "pigz" "unpigz" ];

  nano = [ "nano" "rnano" ];

  tailscale = [ ".tailscaled-wrapped" "tailscale" "tailscaled" ];

  alpine-musl-getent = [ "getent" ];

  iproute2 = [
    "ip" "ss" "tc"
    "ifstat" "lnstat" "nstat" "rtstat" "ctstat"
    "rtacct" "rtmon" 
  ];

  iptables = [
    "iptables" "iptables-apply" "iptables-restore" "iptables-restore-translate" "iptables-save" "iptables-translate" "iptables-xml"
    "iptables-nft" "iptables-nft-restore" "iptables-nft-save" 
    "ip6tables" "ip6tables-apply" "ip6tables-restore" "ip6tables-restore-translate" "ip6tables-save" "ip6tables-translate"
    "ip6tables-nft" "ip6tables-nft-restore" "ip6tables-nft-save"
    "arptables" "arptables-restore" "arptables-save" "arptables-translate"
    "arptables-nft" "arptables-nft-restore" "arptables-nft-save"
    "ebtables" "ebtables-restore" "ebtables-save" "ebtables-translate"
    "ebtables-nft" "ebtables-nft-restore" "ebtables-nft-save"
    "nfbpf_compile" "nfnl_osf" "nfsynproxy" "xtables-monitor" "xtables-nft-multi"
  ];

  kexec-tools = [
    "kexec" "vmcore-dmesg"
  ];

  bash = [
    "bash" "sh"
  ];

  pciutils = [
    "lspci" "pcilmr" "setpci"
  ];

  socat = [
    "socat" "socat1"
  ];
}
