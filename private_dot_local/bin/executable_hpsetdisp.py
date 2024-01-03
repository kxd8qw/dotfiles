#!/usr/bin/env python3

# Python port of hpsetdisp.pl
# (original: $Id: hpsetdisp.pl 11 2006-03-22 01:21:03Z yaakov $)

# hpsetdisp.py
# Connects to a JetDirect equipped HP printer and uses
# HP's control language to set the ready message on the
# LCD display.  Takes an IP address and message as arguments.
# My favorite message is "INSERT COIN".  Keep in mind the
# limitations of the display when composing your clever
# verbiage.
#
# THIS PROGRAM IS PROVIDED WITH NO WARRANTY OF ANY KIND EXPRESSED OR IMPLIED
# THE AUTHOR CANNOT BE RESPONSIBLE FOR THE EFFECTS OF THIS PROGRAM
# IF YOU ARE UNCERTAIN ABOUT THE ADVISABILITY OF USING IT, DO NOT!
#
# Yaakov (http://kovaya.com/)

import socket
import sys

if len(sys.argv) < 3:
  print(f'usage: {sys.argv[0]} <ip address> "<RDYMSG>"')
  sys.exit()
if len(sys.argv) > 3:
  print("Did you forget the quotes around your message?")

peeraddr = sys.argv[1].strip()
rdymsg = sys.argv[2]

data = (
    "\x1b%-12345X@PJL JOB\n"
    f'@PJL RDYMSG DISPLAY="{rdymsg}"\n'
    "@PJL EOJ\n"
    "\x1b%-12345X\n"
)

try:
  with socket.create_connection((peeraddr, 9100)) as sock:
    sock.sendall(data.encode("latin-1", errors="replace"))
except OSError as e:
  sys.exit(f"Could not create socket: {e}")