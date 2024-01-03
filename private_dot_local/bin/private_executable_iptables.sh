#!/usr/bin/env bash

#
# Setup variables
#
IPT="/sbin/iptables"
### Maximum new session packets per second
PPS=5
[[ "$PPS" ]] && PPS="-m limit --limit $PPS/second"
### Log scans
LOG=Y
### Act as a router or stand alone
ROUTER=N
if [[ "$ROUTER" == "Y" ]]; then
  ### External interface
  WAN="eth1"
  ### Internal interface
  LAN="eth0"
  ### Internal Services (SSH, DNS, DHCP, and WWW)
  LTCP=22,53,80,443                     LUDP=53,67
  ### Cut bandwidth to IP or network (Mwu-ha-haha)
  # PUNISH=""
  ### Virtual server IP (the Internet is allowed access select ports on IP)
  VIP="10.0.0.42"
fi
#
# Services to allow inbound connections to
#
### ANtsP2P
#TCP=${TCP:+$TCP,}4567,4568
### BitTorrent
#TCP=${TCP:+$TCP,}6881:6899
### DNS
#UDP=${UDP:+$UDP,}53
### FTP
#TCP=${TCP:+$TCP,}21
### HTTP/HTTPS
#TCP=${TCP:+$TCP,}80,443
### NFS requres several setings to work through a firewall:
#  rpc.statd must be started with the '-p 4000' option
#  /etc/modules.conf needs 'options lockd nlm_UDPport=4001 nlm_TCPport=4001'
#  rpc.mountd must be started with the '-p 4002' option
#  /etc/services needs these lines 'rquotad 4003/TCP' and 'rquotad 4003/UDP'
### NFS (Only local, NFS over the internet is dangerous!)
#LTCP=${LTCP:+$LTCP,}111,2049,4000:4002 LUDP=${LUDP:+$LUDP,}111,2049,4000:4002
### Samba (Only local, SMB over the internet is dangerous!)
#LTCP=${LTCP:+$LTCP,}139,445             LUDP=${LUDP:+$LUDP,}137,138
### SSH
TCP=${TCP:+$TCP,}22
### SMTP mail
#TCP=${TCP:+$TCP,}25
### Rendezvous/ZeroConf (Only local, it doesn't make sense elsewhere)
ZC=y LTCP=${LTCP:+$LTCP,}3689,5298,5335 LUDP=${LUDP:+$LUDP,}5353
### Select the proper connection tracking modules
IPT_MODULES="nf_conntrack_ftp nf_nat_ftp nf_conntrack_irc nf_nat_irc"
### Add IP to talk to DSL
#/sbin/ifconfig $WAN:1 192.168.2.2 netmask 255.255.255.0 broadcast 192.168.2.255

#
# Flush current rules
#
flush () {
  for i in $(cat /proc/net/ip_tables_names 2>&-); do
    $IPT -F -t $i 2>/dev/null
    $IPT -X -t $i 2>/dev/null
    case $i in
      filter) RULES="INPUT FORWARD OUTPUT" ;;
      mangle) RULES="PREROUTING INPUT FORWARD OUTPUT POSTROUTING" ;;
      nat) RULES="PREROUTING POSTROUTING OUTPUT" ;;
    esac
    for j in $RULES; do $IPT -t $i -P $j ACCEPT; done
  done
  $IPT -Z
}

#
# Setup the firewall rules
#
start () {
  ### Load state modules
  for i in $IPT_MODULES; do /sbin/modprobe $i 2>&-; done

  ### Policy
  $IPT -P INPUT DROP
  $IPT -P FORWARD DROP
  $IPT -P OUTPUT ACCEPT

  #
  # Create a grey IP filter
  #
  $IPT -N grey
  $IPT -A grey -s 10.0.0.0/8 -j DROP
  $IPT -A grey -s 127.0.0.0/8 -j DROP
  $IPT -A grey -s 172.16.0.0/12 -j DROP
  $IPT -A grey -s 192.168.0.0/16 -j DROP
  $IPT -A grey -s 169.254.0.0/16 -j DROP

  #
  # Create filter that blocks unwanted inbound IP connections
  #
  $IPT -N ip-in
  ### Only useful inbound ICMP (unreachable, ping, pong, traceroute reply)
  $IPT -A ip-in -p icmp --icmp-type 3 -m conntrack \
        --ctstate ESTABLISHED,RELATED $PPS ! -f -j ACCEPT
  $IPT -A ip-in -p icmp --icmp-type 8 $PPS ! -f -j ACCEPT
  $IPT -A ip-in -p icmp --icmp-type 0 -m conntrack \
        --ctstate ESTABLISHED,RELATED $PPS ! -f -j ACCEPT
  $IPT -A ip-in -p icmp --icmp-type 11 -m conntrack \
        --ctstate ESTABLISHED,RELATED $PPS ! -f -j ACCEPT
  $IPT -A ip-in -p icmp -j DROP
  [[ "$PUNISH" ]] && $IPT -A ip-in -s $PUNISH -m random --average 33 -j DROP
  ### Block and log (if desired) scans
  if [[ "$LOG" == Y ]]; then
    $IPT -A ip-in -p TCP --tcp-flags ALL FIN,URG,PSH -m limit -j LOG \
          --log-prefix "NMAP-XMAS SCAN:" --log-tcp-options \
          --log-ip-options
    $IPT -A ip-in -p TCP --tcp-flags ALL NONE -m limit -j LOG \
          --log-prefix "NMAP-NULL SCAN:" --log-tcp-options \
          --log-ip-options
    $IPT -A ip-in -p TCP --tcp-flags ALL ALL -m limit -j LOG \
          --log-prefix "NMAP-FLUSH SCAN:" --log-tcp-options \
          --log-ip-options
    $IPT -A ip-in -p TCP --tcp-flags SYN,RST SYN,RST -m limit -j LOG \
          --log-prefix "SYN/RST SCAN:" --log-tcp-options \
          --log-ip-options
    $IPT -A ip-in -p TCP --tcp-flags SYN,FIN SYN,FIN -m limit -j LOG \
          --log-prefix "SYN/FIN SCAN:" --log-tcp-options \
          --log-ip-options
    # $IPT -A ip-in -m unclean -m limit --j LOG \
    #           --log-prefix "UNCLEAN:" --log-ip-options
  fi
  $IPT -A ip-in -p TCP --tcp-flags ALL FIN,URG,PSH -j DROP
  $IPT -A ip-in -p TCP --tcp-flags ALL NONE -j DROP
  $IPT -A ip-in -p TCP --tcp-flags ALL ALL -j DROP
  $IPT -A ip-in -p TCP --tcp-flags SYN,RST SYN,RST -j DROP
  $IPT -A ip-in -p TCP --tcp-flags SYN,FIN SYN,FIN -j DROP
  # $IPT -A ip-in -m unclean -j DROP
  if [[ "$ROUTER" == "Y" ]]; then
    ### Setup a safe host
    $IPT -A ip-in -i $LAN -s 10.0.0.22 -j ACCEPT
    #$IPT -A ip-in -i $WAN -s 192.168.2.2/32 -j ACCEPT
    #$IPT -A ip-in -i $WAN -s 172.30.42.2/32 -j ACCEPT
    $IPT -A ip-in -i $WAN -j grey
  fi

  #
  # Create filter that blocks unwanted outbound IP connections
  #
  $IPT -N ip-out
  ### Only useful outbound ICMP (source quench, ping, pong)
  $IPT -A ip-out -p icmp --icmp-type 4 -j ACCEPT
  $IPT -A ip-out -p icmp --icmp-type 8 -j ACCEPT
  $IPT -A ip-out -p icmp --icmp-type 0 -j ACCEPT
  $IPT -A ip-out -p icmp -j DROP
  if [[ "$ROUTER" == "Y" ]]; then
    ### Don't let NetBIOS/CIFS leave the network
    $IPT -A ip-out -o $WAN -p TCP -m multiport --dports 135:139,445 -j REJECT
    $IPT -A ip-out -o $WAN -p TCP -m multiport --sports 135:139,445 -j REJECT
    $IPT -A ip-out -o $WAN -p UDP -m multiport --dports 135:139,445 -j REJECT
    $IPT -A ip-out -o $WAN -p UDP -m multiport --sports 135:139,445 -j REJECT
  fi

  #
  # Setup the INPUT rule filter
  #
  ### Allow loopback & wanted services
  $IPT -A INPUT -i lo -j ACCEPT
  $IPT -A INPUT -j ip-in
  ### Let connections already setup continue
  $IPT -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  if [[ "$ROUTER" != "Y" || -z "$VIP" ]]; then
    [[ "$TCP" ]] && $IPT -A INPUT -p TCP -m multiport --dports $TCP \
          --tcp-flags ALL SYN $PPS ! -f -j ACCEPT
    [[ "$UDP" ]] && $IPT -A INPUT -p UDP -m multiport --dports $UDP \
          $PPS -j ACCEPT
  fi
  [[ "$LTCP" ]] && $IPT -A INPUT ${WAN:+-i ! $WAN} -p TCP -m multiport \
        --dports $LTCP --tcp-flags ALL SYN $PPS ! -f -j ACCEPT
  [[ "$LUDP" ]] && $IPT -A INPUT ${WAN:+-i ! $WAN} -p UDP -m multiport \
        --dports $LUDP $PPS -j ACCEPT
  [[ "$ZC" ]] && {
    $IPT -A INPUT -s 224.0.0.0/4 ${WAN:+-i ! $WAN } $PPS -j ACCEPT
    $IPT -A INPUT -s 169.254.0.0/16 ${WAN:+-i ! $WAN } $PPS -j ACCEPT; }

  #
  # Setup the FORWARD rule filter
  #
  if [[ "$ROUTER" == "Y" ]]; then
    $IPT -A FORWARD -j -i $WAN ip-in
    $IPT -A FORWARD -j -o $WAN ip-out
    $IPT -t nat -A POSTROUTING -o $WAN -j MASQUERADE
    ### Let connections already setup continue
    $IPT -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    ### Setup services on the VIP
    if [[ "$VIP" ]]; then
      [[ "$TCP" ]] && $IPT -t nat -A PREROUTING -p TCP -m multiport \
            --dports $TCP --tcp-flags ALL SYN $PPS ! -f -j DNAT \
            --to $VIP
      [[ "$UDP" ]] && $IPT -t nat -A PREROUTING -p UDP -m multiport \
            --dports $UDP $PPS -j DNAT --to $VIP
      $IPT -t nat -A POSTROUTING -i $LAN -o $LAN -j MASQUERADE
      $IPT -A FORWARD -d $VIP $PPS -j ACCEPT
    fi
  fi

  #
  # Setup the OUTPUT rule filter
  #
  ### Loopback action
  $IPT -A OUTPUT -o lo -j ACCEPT
  $IPT -A OUTPUT -j ip-out
}

### Turn on routing if needed
if [[ "$ROUTER" == "Y" ]]; then
  echo 1 >/proc/sys/net/ipv4/ip_forward
else
  echo 0 >/proc/sys/net/ipv4/ip_forward
fi

### Set ip options for better security
echo 0 >/proc/sys/net/ipv4/conf/all/accept_redirects
echo 0 >/proc/sys/net/ipv4/conf/all/accept_source_route
echo 1 >/proc/sys/net/ipv4/conf/all/rp_filter
echo 1 >/proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 1 >/proc/sys/net/ipv4/tcp_syncookies

case $* in
  stop) echo -n "Stoping firewall..."
    flush
    echo " done."
    ;;
  *) echo -n "Starting firewall..."
    flush
    start
    echo " done."
    ;;
esac