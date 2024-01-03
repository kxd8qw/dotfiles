#!/usr/bin/env bash

basedir='/storage/emulated/0'
dir='Stuff/Android'

. $(dirname $(which $(basename $0)))/functions
opt='-LPrsy --rsh="ssh -x" --delete --size-only'

### Sync up
sync() { local dest=$1
  echo -e "\n${blu}Books${nc}: ${grn}Computer${nc} <==> ${grn}${dest}${nc}"
  eval rsync $opt --exclude .FBReader $dir/Books/ $dest:$basedir/Books/

  #echo -e "\n${blu}Music${nc}: ${grn}Computer${nc} <==> ${grn}${dest}${nc}"
  #eval rsync $opt --delete-excluded --exclude "*.jpg" --exclude "*.png" \
  #      --exclude "*.pdf" --exclude imgs --exclude '*"*' Music/* \
  #      $dest:$basedir/Music/

  echo -e "\n${blu}Podcasts${nc}: ${grn}Computer${nc} <==> ${grn}${dest}${nc}"
  #eval rsync -c $opt Voice/Podcasts $dest:$basedir/Music/
  eval rsync $opt $dir/Playlists/ Voice/Podcasts/ $dest:$basedir/Podcasts/

  echo -e "\n${blu}Videos${nc}: ${grn}Computer${nc} <==> ${grn}${dest}${nc}"
  eval rsync $opt --max-size 256M Videos/Sync/ $dest:$basedir/Movies/

  if [[ $dest == "zok2" && ! "$new" ]]; then
    echo -e "\n${blu}Android${nc}: ${grn}${dest}${nc} <==> ${grn}home${nc}"
    eval rsync $opt $HOME/Documents/Cool/hashing_hymns.txt \
          $HOME/Private/Passwords.kdbx $dest:$basedir/firmware/
    for i in dcim download firmware; do
      eval rsync -LPasy --rsh="ssh -x" --delete --modify-window=2 \
            --delete-excluded --exclude .thumbnails --exclude cache\
            --exclude dropbear* --exclude Passwords.kdbx \
            --exclude hashing_hymns.txt $dest:$basedir/$i $dir/
    done
  fi
}

cd

### Check ssh-agent status, and start it, if needed:
sshcheck

### Prep
echo -n "Prepping: "
[[ "$1" != "-q" ]] && {
  echo -n "books... "
  temp=$(mktemp)
  find -L $dir/Books/ -type l -exec rm {} \;
  find Documents/ -type f >$temp
  [[ -d $dir/Books ]] || { rm -rf $dir/Books; mkdir -p $dir/Books; }
  (cd $dir/Books; find -print0) | xargs -0 -P$(nproc) -I'{}' bash -c \
        "grep -qs '{}' $temp || rm '$dir/Books/{}'"
  rm $temp
  find Documents/ -iname \*.epub -print0 | xargs -0 -P$(nproc) -I'{}' bash -c\
        '[[ -h "'"$dir"'/Books/$(basename '"'"'{}'"'"')" ]] ||
        ln -rs '"'"'{}'"'"' '"$dir"'/Books/'
} || shift

echo -n "playlists... "
[[ -d $dir/Playlists ]] ||{ rm -rf $dir/Playlists;mkdir -p $dir/Playlists; }
[[ -f $dir/Playlists/.nomedia ]] || touch $dir/Playlists/.nomedia
rm -f $dir/Playlists/*
#for i in Voice/Podcasts/*mp3; do
#  album=$(gettag "$i" album | sed 's/  */_/g; s/[^-0-9A-Za-z,._]//g
#        s/^$/MISC/')
#  echo "${i/*\//}" >>$dir/Playlists/$album.m3u
#done

[[ "$1" == "-n" ]] && {
  new=1
  shift
}

if [[ "$@" ]]; then
  for i; do sync "$i"; done
elif (fping zok || fping zok2 || fping nexus7) &>/dev/null; then
  fping zok &>/dev/null && sync zok
  fping zok2 &>/dev/null && sync zok2
  fping nexus7 &>/dev/null && sync nexus7
else
  echo "ERROR: ${0##/}: No destination system given"; exit 1
fi