#!/usr/bin/env perl

  # $Id: hpsetdisp.pl 11 2006-03-22 01:21:03Z yaakov $

  # hpsetdisp.pl
  # Connects to a JetDirect equipped HP printer and uses
  # HP's control language to set the ready message on the
  # LCD display.  Takes an IP address and message on STDIN.
  # My favorite message is "INSERT COIN".  Keep in mind the
  # limitations of the display when composing your clever
  # verbiage.
  #
  # THIS PROGRAM IS PROVIDED WITH NO WARRANTY OF ANY KIND EXPRESSED OR IMPLIED
  # THE AUTHOR CANNOT BE RESPONSIBLE FOR THE EFFECTS OF THIS PROGRAM
  # IF YOU ARE UNCERTAIN ABOUT THE ADVISABILITY OF USING IT, DO NOT!
  #
  # Yaakov (http://kovaya.com/)

use strict;
use warnings;

unless (@ARGV) { print "usage: $0 <ip address> \"<RDYMSG>\"\n" ; exit }
if ($ARGV[3]) { print "Did you forget the quotes around your message?\n" }

my $peeraddr = $ARGV[0];
my $rdymsg = $ARGV[1];
chomp $peeraddr;

use IO::Socket;
my $socket = IO::Socket::INET->new(
    PeerAddr  => $peeraddr,
    PeerPort  => "9100",
    Proto     => "tcp",
    Type      => SOCK_STREAM
    ) or die "Could not create socket: $!";

my $data = <<EOJ
\e%-12345X\@PJL JOB
\@PJL RDYMSG DISPLAY="$rdymsg"
\@PJL EOJ
\e%-12345X
EOJ
;

print $socket $data;