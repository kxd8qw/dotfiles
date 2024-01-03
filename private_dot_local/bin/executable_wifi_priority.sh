#!/usr/bin/env bash

usage() {
  echo "Usage: $(basename $0)"' [option] [priority#]

Options:
  -h          This help.
  -d or -f    Delete priority settings

ACs map directly from Ethernet-level class of service (CoS) 802.1p levels
[802.1d]      [802.1d]    [802.1d]        [802.11e]               [802.11e]
802.1p Pri    802.1p Name Traffic         Access Category (AC)    Name
1 (low)       BK          Background      AC_BK                   Background
2             -           (spare)         AC_BK                   Background
0             BE          Best Effort     AC_BE                   Best Effort
3             EE          Excellent Effort AC_BE                  Best Effort
4             CL          Controlled Load AC_VI                   Video
5             VI          Video           AC_VI                   Video
6             VO          Voice           AC_VO                   Voice
7 (high)      NC          Network Control AC_VO                   Voice'
  exit
}
ipt() {
  iptables $*
  ip6tables $*
} 2>/dev/null

### verifiy access
id | cut -d' ' -f1 | grep -qs '(root)' || {
  echo "$(basename $0): needs root to run iptables"
  exit 1
}

### clear previous runs
iptables -t mangle -S | sed -n '/dscp/s/-A/-D/p' | while read j; do
  ipt -t mangle $j
done

### read args
while getopts ":hdf" opt; do
  case "$opt" in
    d|f) exit ;;
    h) usage ;;
    "?") echo "Unknown option: -$OPTARG"; usage ;;
    ":") echo "No argument value for option: -$OPTARG"; usage ;;
  esac
done
shift $(( OPTIND - 1 ))

### set the priority
for i in $(iwconfig 2>&- | awk '/SSID/ {print $1}'); do
  ipt -t mangle -A POSTROUTING -o $i -j DSCP --set-dscp ${1:-5}
done