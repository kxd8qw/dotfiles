#!/usr/bin/env -S bash
set -euxo pipefail

[[ -d "${HOME}/.local/bin" ]] || mkdir -p "${HOME}/.local/bin"
[[ -d "${HOME}/.config/ohmyzsh/functions" ]] ||
      mkdir -p "${HOME}/.config/ohmyzsh/functions"

get_git_pkg() { local prj="$1" filter="$2" out="$3" url
  PATH=/bin:/usr/bin:/usr/local/bin type -p "${4:-${prj##*/}}" >/dev/null &&
        return 1 || :
  url=$(curl -LSs "https://api.github.com/repos/$prj/releases" |
        jq -r "$filter")
  curl -LSs "$url" -o "$out"
}

trim() { local i sudo='' sudow='' temp
  for i in "$@"; do
    [[ -e "$i" ]] || continue
    [[ -r "$i" ]] || sudo=sudo; [[ -w "$i" ]] || sudow=sudo
    temp="/tmp/trim-${1/*\//}"
    $sudo sed "s/\r\$//; s/[	 ]*\$//" "$i" >"$temp"
    sed -iz 's/\n*$//' "$temp"
    [[ $(tail -c1 "$temp" | wc -l) -gt 0 ]] && truncate -s -1 "$temp"
    { $sudo diff "$i" "$temp" || cat "$temp" | $sudow tee "$i"; } >/dev/null
    \rm -f "$temp"
  done
}

update_file() { local file="$1" temp="/tmp/${1##*/}"
  trim "$temp" >/dev/null 2>&1 || :
  if diff -q "$temp" "$file" >/dev/null 2>&1; then
    rm "$temp"
  else
    mv -v "$temp" "$file"
  fi
}

if [[ ! -x "${HOME}/.local/bin/jq" ]]; then
  url="https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64"
  curl -L "$url" -o "${HOME}/.local/bin/jq"
  unset url
  chmod +x "${HOME}/.local/bin/jq"
fi

f='.[0].assets[]|select(.name|test("x86_64.*musl")).browser_download_url'
get_git_pkg "sharkdp/bat" "$f" "/tmp/bat.tgz" && {
  tar -C /tmp -xf "/tmp/bat.tgz"
  cp /tmp/bat*/bat "${HOME}/.local/bin/"
  rm -rf /tmp/bat*
}
URL="https://github.com/sharkdp/bat/raw/master/assets/completions"
curl -LSs "$URL/bat.zsh.in" -o /tmp/_bat
update_file "${HOME}/.config/ohmyzsh/functions/_bat"

f='.[0].assets[]|select(.name|test("ux-musl_amd64")).browser_download_url'
get_git_pkg "twpayne/chezmoi" "$f" "/tmp/chezmoi.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/chezmoi.tgz" chezmoi
  rm "/tmp/chezmoi.tgz"
}
chezmoi completion zsh --output=/tmp/_chezmoi
update_file "${HOME}/.config/ohmyzsh/functions/_chezmoi"

f='.[0].assets[]|select(.name|test("linux-musl.tar")).browser_download_url'
get_git_pkg "dandavison/delta" "$f" "/tmp/delta.tgz" && {
  tar -C /tmp -xf "/tmp/delta.tgz"
  cp /tmp/delta*/delta "${HOME}/.local/bin/"
  rm -rf /tmp/delta*
}
URL="https://github.com/dandavison/delta/raw/main/etc/completion"
curl -LSs "$URL/completion.zsh" -o /tmp/_delta
update_file "${HOME}/.config/ohmyzsh/functions/_delta"

f='.[0].assets[]|select(.name|test("linux-musl.tar")).browser_download_url'
get_git_pkg "eza-community/eza" "$f" "/tmp/eza.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/eza.tgz"
  rm "/tmp/eza.tgz"
}
URL="https://github.com/eza-community/eza/raw/main/completions/zsh/_eza"
curl -LSs "$URL" -o /tmp/_eza
update_file "${HOME}/.config/ohmyzsh/functions/_eza"

f='.[0].assets[]|select(.name|test("x86_64.*musl")).browser_download_url'
get_git_pkg "sharkdp/fd" "$f" "/tmp/fd.tgz" && {
  tar -C /tmp -xf "/tmp/fd.tgz"
  cp /tmp/fd*/fd "${HOME}/.local/bin/"
  rm -rf /tmp/fd*
}
URL="https://github.com/sharkdp/fd/raw/master/contrib/completion/_fd"
curl -LSs "$URL" -o /tmp/_fd
update_file "${HOME}/.config/ohmyzsh/functions/_fd"

f='.[0].assets[]|select(.name|test("linux_amd64")).browser_download_url'
get_git_pkg "junegunn/fzf" "$f" "/tmp/fzf.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/fzf.tgz" fzf
  rm "/tmp/fzf.tgz"
}
fzf --zsh >/tmp/_fzf
update_file "${HOME}/.config/ohmyzsh/functions/_fzf"

f='.[0].assets[]|select(.name|test("linux-amd64")).browser_download_url'
get_git_pkg "jqlang/jq" "$f" "${HOME}/.local/bin/jq" && {
  chmod +x "${HOME}/.local/bin/jq"
}

f='.[0].assets[]|select(.name|test("x86_64.*musl.*gz$")).browser_download_url'
get_git_pkg "casey/just" "$f" "/tmp/just.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/just.tgz" just
  rm -rf /tmp/just.tgz
}
URL="https://github.com/casey/just/raw/master/completions/just.zsh"
curl -LSs "$URL" -o /tmp/_just
update_file "${HOME}/.config/ohmyzsh/functions/_just"

f='.[0].assets[]|select(.name|test("linux64.tar")).browser_download_url'
get_git_pkg "neovim/neovim-releases" "$f" "/tmp/neovim.tgz" "nvim" && {
  rm -rf "${HOME}/.local/nvim-linux64"
  tar -C "${HOME}/.local" -xf "/tmp/neovim.tgz"
  yes | ln -frs "${HOME}/.local/nvim-linux64/bin/nvim" "${HOME}/.local/bin/" ||:
  rm -rf "/tmp/neovim.tgz"
}
URL="https://github.com/NoahTheDuke/vim-just/raw/main/syntax/just.vim"
curl -LSs "$URL" -o /tmp/just.vim
update_file "${HOME}/.local/nvim-linux64/share/nvim/runtime/syntax/just.vim"

URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh"
URL="$URL-linux-amd64"
curl -LSs "$URL" -o "${HOME}/.local/bin/oh-my-posh"
chmod +x "${HOME}/.local/bin/oh-my-posh"

f='.[0].assets[] | select(.name|test("x86_64.*linux")) | .browser_download_url'
ver=$(rpm -qa | awk '/glibc-[0-9]/ {sub(/^[^-]*-/, ""); sub (/-.*/, "");print}')
if [[ "$ver" =~ ^2.29|^2.[3-9]|^[3-9] ]]; then
  get_git_pkg "aaronriekenberg/rust-parallel" "$f" "/tmp/parallel.tgz" \
        "parallel" && {
    tar -C /tmp -xf /tmp/parallel.tgz
    cp /tmp/rust-parallel "${HOME}/.local/bin/parallel"
    rm -rf /tmp/*parallel*
  }
fi

f='.[0].assets[]|select(.name|test("_64.*musl.tar.gz$")).browser_download_url'
get_git_pkg "BurntSushi/ripgrep" "$f" "/tmp/ripgrep.tgz" "rg" && {
  tar -C /tmp -xf "/tmp/ripgrep.tgz"
  cp /tmp/ripgrep*/rg "${HOME}/.local/bin/"
  rm -rf /tmp/ripgrep*
}
# zsh completion is in a omz plugin

f='.[0].assets[]|select(.name|test("x86_64.*musl")).browser_download_url'
get_git_pkg "ajeetdsouza/zoxide" "$f" "/tmp/zoxide.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/zoxide.tgz" zoxide
  rm -rf /tmp/zoxide.tgz
}

#{ set +x; } 2>&-