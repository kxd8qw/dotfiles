#!/usr/bin/env bash
set -euo pipefail

nc="$(tput sgr0 2>&- || echo '[0;39m')"
bld="$nc$(tput bold 2>&-)"
blu="$bld$(tput setaf 4 2>&- || echo '[1;34m')"
cya="$nc$(tput setaf 6 2>&- || echo '[0;36m')"
grn="$nc$(tput setaf 2 2>&- || echo '[0;32m')"
mag="$bld$(tput setaf 5 2>&- || echo '[1;35m')"
red="$bld$(tput setaf 1 2>&- || echo '[1;31m')"
yel="$nc$(tput setaf 3 2>&- || echo '[0;33m')"
ce="$nc$(tput hpa 0 2>&-; tput ed 2>&- || echo '[0\`[0j')"

sync() { local loc="$1" rem="zandor:$1" exc="${2:-""}"
  [[ -n "$exc" ]] && exc=$(sed -E 's/(^| +)/ --exclude /g' <(echo "$exc"))
  echo -e "\n${grn}${loc}${nc}:"
  if [[ -e ${loc} || -n ${dl:-""} ]]; then
    rsync -AHUXPayu --existing ${exc} ${loc} ${rem}
    echo -n "${mag}"
    rsync -AHUXPay --delete-after --dry-run ${exc} ${loc} ${rem} | tail -n +3
    echo -n "${nc}"
  fi
  rsync -AHUXPay --delete-after ${exc} ${rem} ${loc} |
        sed -E 's|(deleting)|'"${red}"'\1'"${nc}"'|g'
}

#sync Private/
exclude="excel iexplore infopath msaccess mspscan mspub mspview offdiag ois"
exclude+=" outlook powerpnt servicemanager setlang visio winword"
sync .local/bin/ "$exclude"
#sync .abcde.conf
#sync .bashrc
#sync .bash_logout
#sync .bpodder/ "temp"
sync .cert/ "nm-openvpn"
#sync .config/starship.toml
sync .config/nvim/ "nviminfo undo"
sync .config/ohmyzsh/ "cache"
sync .config/tmux/
#sync .config/vim/ "viminfo undo"
#sync .exrc
sync .gitconfig
sync .gnupg/ "S.gpg-agent private-keys-v1.d scdaemon.conf"
sync .inputrc
sync .mozilla/saved/
sync .mozilla/user.js
sync .mozilla/userChrome.css
sync .mozilla/userContent.css
sync .muttrc
sync .netrc
#sync .profile
#sync .profile_local
sync .ssh/ "agent* id_dsa.keystore environment* remote_mux*"
#sync .vimrc
sync .zlogout
sync .zshrc