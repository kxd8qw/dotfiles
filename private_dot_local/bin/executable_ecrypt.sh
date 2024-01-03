#!/usr/bin/env bash

app=$0
dir=$(dirname $app)/Data/home

opts="key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16"
opts="$opts,ecryptfs_passthrough=no,ecryptfs_enable_filename_crypto=yes"
opts="$opts,ecryptfs_sig=61ac5966f58298c6,ecryptfs_fnek_sig=61ac5966f58298c6"

if [[ "$(mount)" =~ $dir ]]; then
  sudo umount $dir
else
  sudo mount -t ecryptfs -o $opts $dir $dir
fi