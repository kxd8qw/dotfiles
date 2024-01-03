#!/usr/bin/env -S bash
#===============================================================================
#          FILE: work.sh
#
#         USAGE: ./work.sh
#
#   DESCRIPTION: Start or stop work utilities and openconnect VPN
#
#       OPTIONS: -s | -q | -h | -d | -u | -h | -S | -w
#  REQUIREMENTS: OSX (for app start/stop), openconnect, and tuntap
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: David Personette (DP),
#  ORGANIZATION: Thomson Reuters
#       CREATED: 2014-04-03 08:49
#      REVISION: 1.6
#===============================================================================

set -o nounset                              # Treat unset variables as an error

apps=( "Cisco Jabber" "Google Chrome" "Mail" )

DNS="167.68.250.92 167.68.251.92"
ROUTES="10.0.0.0/8 163.231.0.0/16 167.68.0.0/16"
URL="https://eag2.vpn.thomsonreuters.com"
openconnect=$(which openconnect)

### update_DNS: Update OSX DNS
# Arguments:
#   servers) DNS servers to use
# Return: none
update_DNS() { local servers="$*"
  [[ $(uname) =~ Darwin ]] || return 0
  networksetup -listallnetworkservices|egrep 'Ethernet|Wi-Fi'|while read i; do
        sudo networksetup -setdnsservers "$i" $servers
  done
}
### start_oc: Start openconnect VPN tunnel
# Arguments:
#   ADPW) optional provide the password
# Return: text
start_oc() { local ADPW
  [[ -x $openconnect ]] || { echo "ERROR: openconnect not found"; exit 1; }
  [[ $(uname -s) =~ Darwin ]] && { [[ $(kextstat) =~ tun ]] || sudo kextload \
        /Library/Extensions/tun.kext; }
  [[ $(uname -s) =~ Darwin ]] && { [[ $(kextstat) =~ tun ]] || {
      echo "ERROR: tuntap modules must be installed/loaded"
      echo -e "\nPlease see 'brew info tuntap' or google 'macports tuntap'\n"
      exit 1
    }
  }
  config_oc

  echo "Starting VPN..."
  stop_oc >/dev/null
  read -e -p "AD password> " -r -s ADPW && echo -e "\n"
  echo $ADPW | sudo $openconnect --config=.cert/openconnect --no-cert-check \
        --csd-user=nobody --csd-wrapper=$HOME/.cert/csd-wrapper $URL ||
        { echo "Connection FAILED! (incorrect password?)"; exit 2; }
  update_DNS "$DNS"
}
### stop_oc: Stop openconnect VPN tunnel
# Arguments:
#   N/A) no inputs
# Return: text
stop_oc() {
  echo "Stopping VPN..."
  [[ "$(ps -ef)" =~ openconnect ]] && sudo pkill openconnect
  update_DNS Empty
  sleep 1
}
### status_oc: Status of VPN tunnel
# Arguments:
#   N/A) no inputs
# Return: text - VPN status; 0 if running; 1 otherwise
status_oc() {
  [[ "$(ps -ef)" =~ openconnect ]] &&
        { echo "VPN running"; return 0; } ||
        { echo "VPN stopped"; update_DNS Empty; return 1; }
}
### config_oc: Setup openconnect configuration
# Arguments:
#   N/A) no inputs
# Return: none
config_oc() { local p12="" key user vpncscript
  [[ -r .cert/openconnect ]] || {
    until [[ -r $p12 ]]; do read -e -p"Full path to p12 file> " -r p12; done
    read -e -p"Password for cert> " -r key
    read -e -p"Your AD \"DOMAIN\username\"> " -r user

    ### create .cert/openconnect
    echo -e "authgroup=Anyconnect-Cert\nbackground\ncertificate=$p12
          key-password=$key\nno-cert-check\npasswd-on-stdin\nquiet
          script=$HOME/.cert/openconnect-script\nuser=$user" |
          sed 's/^ *//' >.cert/openconnect
  }
  [[ -x .cert/openconnect-script ]] || {
    vpncscript=$( (find /usr/local; find /opt; find /etc; find /usr/share) \
          2>/dev/null | grep '/vpnc-script$' | head -1)
    [[ -x $vpncscript ]] || {
      vpncscript="http://git.infradead.org/users/dwmw2/vpnc-scripts.git"
      curl -LSfs $vpncscript/blob_plain/HEAD:/vpnc-script >.vpnc-script
      vpncscript="$HOME/.vpnc-script"; chmod +x $vpncscript
    }

    ### create .cert/openconnect-script
    echo -e '#!/bin/sh\n\nINTERNAL_IP4_DNS="'"$DNS"'"\nROUTES="'"$ROUTES"'"
          \n# Helpers to create dotted-quad netmask strings.
          MASKS[1]=128.0.0.0\nMASKS[2]=192.0.0.0\nMASKS[3]=224.0.0.0
          MASKS[4]=240.0.0.0\nMASKS[5]=248.0.0.0\nMASKS[6]=252.0.0.0
          MASKS[7]=254.0.0.0\nMASKS[8]=255.0.0.0\nMASKS[9]=255.128.0.0
          MASKS[10]=255.192.0.0\nMASKS[11]=255.224.0.0\nMASKS[12]=255.240.0.0
          MASKS[13]=255.248.0.0\nMASKS[14]=255.252.0.0\nMASKS[15]=255.254.0.0
          MASKS[16]=255.255.0.0\nMASKS[17]=255.255.128.0\nMASKS[18]=255.255.192.0
          MASKS[19]=255.255.224.0\nMASKS[20]=255.255.240.0
          MASKS[21]=255.255.248.0\nMASKS[22]=255.255.252.0
          MASKS[23]=255.255.254.0\nMASKS[24]=255.255.255.0
          MASKS[25]=255.255.255.128\nMASKS[26]=255.255.255.192
          MASKS[27]=255.255.255.224\nMASKS[28]=255.255.255.240
          MASKS[29]=255.255.255.248\nMASKS[30]=255.255.255.252
          MASKS[31]=255.255.255.254\n\nexport CISCO_SPLIT_INC=0\n
          # Create environment variables vpnc-script uses to configure the network
          function addroute() { local RT="$1"
            export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_ADDR=${RT%%/*}
            export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASKLEN=${RT##*/}
            export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASK=${MASKS[${RT##*/}]}
            export CISCO_SPLIT_INC=$((${CISCO_SPLIT_INC}+1))
          }\n\nfor i in $ROUTES; do\n    addroute $i\ndone\n
          exec '"$vpncscript" | sed 's/^        //' >.cert/openconnect-script
    chmod +x .cert/openconnect-script
  }
}
### pass: Get 'safe' passwd from lastpass
# Arguments:
#   N/A) no input
# Return: password in clipboard
pass() {
  [[ -x $(which lpass 2>&1) ]] &&
        lpass show -c --password $(lpass ls|grep -i ${1:-safe}|sed 's/ \[.*//')
  exit
}

### startwork: Start work apps
# Arguments:
#   N/A) no input
# Return: N/A
startwork() { local i
  #fping bacon.int.westgroup.com &>/dev/null || { start_oc || exit 1; }
  fping bacon.int.westgroup.com &>/dev/null || { ssh -qO exit home
        open -a "Cisco AnyConnect Secure Mobility Client" || exit 1; sleep 20; }
  [[ $(uname -s) =~ Darwin ]] && for (( i = 0; i < ${#apps[@]}; i++ )); do
    open -a "${apps[$i]}" -g
  done
  exit
}
### quitwork: Stop work apps
# Arguments:
#   N/A) no input
# Return: N/A
quitwork() { local i
  [[ $(uname -s) =~ Darwin ]] && for (( i = 0; i < ${#apps[@]}; i++ )); do
    osascript -e 'tell app "'"${apps[$i]}"'" to Quit'
  done
  status_oc && stop_oc
  osascript -e'tell app "'"Cisco AnyConnect Secure Mobility Client"'" to Quit'
  exit
}
### usage: How to use this script
# Arguments:
#   N/A) no input
# Return: N/A
usage() {
  echo "$(basename $0): Usage: $(basename $0) <opt>"
  echo "  -d          Down the VPN"
  echo "  -u          Bring Up the VPN"
  echo "  -S          Status: is the VPN running"
  echo "  -p          Copy lastpass 'safe' passwd to clipboard"
  echo "  -w          Wipe VPN configuration / reconfigure"
  echo "  -s          Start Work Applications and VPN"
  echo "  -q          Quit Work Applications and VPN"
  echo "  -h          This help"
  exit
}

while getopts ":duSpwsqh" opt; do
  case "$opt" in
    d) stop_oc; exit ;;
    u) start_oc; exit ;;
    S) status_oc; exit ;;
    p) pass "${2:-}" ;;
    w) rm -f .cert/openconnect*; config_oc ;;
    s) startwork ;;
    q) quitwork ;;
    h) usage ;;
    "?") echo "Unknown option: -$OPTARG"; usage ;;
    ":") echo "No argument value for option: -$OPTARG"; usage ;;
  esac
done
shift $(( OPTIND - 1 ))
[[ $# -ge 1 ]] || usage