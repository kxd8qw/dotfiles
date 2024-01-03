#!/usr/bin/env -S bash

dev=enp0s20f0
key=UMaFUjsnXyHLGNMjcXBvLsDg
ip=$([[ -n $1 ]] && echo "$1" || ip addr show dev "$dev" |
      awk '/2601:5c2:0/ {sub(/\/.*/, "", $2); print $2; exit}')

for domain in au2pb.org dperson.net; do
  if [[ -n $1 ]] || ! host "$domain" | grep -q "$ip"; then
    url=https://dns.api.gandi.net/api/v5/domains/$domain/records/@/AAAA
    set -x
    curl -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $key" \
          -sd '{"rrset_ttl": 1800, "rrset_values": ["'"$ip"'"]}' $url ||
          echo 'FAILED!!!'
    { set +x; echo; } 2>&-
  fi
done