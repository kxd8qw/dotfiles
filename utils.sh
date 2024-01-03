#!/usr/bin/env -S bash
set -euxo pipefail

[[ -d "${HOME}/.local/bin" ]] || mkdir -p "${HOME}/.local/bin"

if [[ ! -x "${HOME}/.local/bin/jq" ]]; then
  url="https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64"
  curl -L "$url" -o "${HOME}/.local/bin/jq"
  unset url
  chmod +x "${HOME}/.local/bin/jq"
fi

get_git_pkg() { local prj="$1" filter="$2" out="$3" url
  PATH=/bin:/usr/bin:/usr/local/bin type -p "${4:-${prj##*/}}" >/dev/null &&
        return 1 || :
  url=$(curl -LSs "https://api.github.com/repos/$prj/releases" |
        jq -r "$filter")
  curl -LSs "$url" -o "$out"
}

f='.[0].assets[]|select(.name|test("x86_64.*musl")).browser_download_url'
get_git_pkg "sharkdp/bat" "$f" "/tmp/bat.tgz" && {
  tar -C /tmp -xf "/tmp/bat.tgz"
  cp /tmp/bat*/bat "${HOME}/.local/bin/"
  rm -rf /tmp/bat*
} || :

f='.[0].assets[]|select(.name|test("ux-musl_amd64")).browser_download_url'
get_git_pkg "twpayne/chezmoi" "$f" "/tmp/chezmoi.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/chezmoi.tgz"
  rm "/tmp/chezmoi.tgz"
} || :

f='.[0].assets[]|select(.name|test("linux-musl.tar")).browser_download_url'
get_git_pkg "dandavison/delta" "$f" "/tmp/delta.tgz" && {
  tar -C /tmp -xf "/tmp/delta.tgz"
  cp /tmp/delta*/delta "${HOME}/.local/bin/"
  rm -rf /tmp/delta*
} || :

f='.[0].assets[]|select(.name|test("linux-musl.tar")).browser_download_url'
get_git_pkg "eza-community/eza" "$f" "/tmp/eza.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/eza.tgz"
  rm "/tmp/eza.tgz"
} || :

f='.[0].assets[]|select(.name|test("x86_64.*musl")).browser_download_url'
get_git_pkg "sharkdp/fd" "$f" "/tmp/fd.tgz" && {
  tar -C /tmp -xf "/tmp/fd.tgz"
  cp /tmp/fd*/fd "${HOME}/.local/bin/"
  rm -rf /tmp/fd*
} || :

f='.[0].assets[]|select(.name|test("linux_amd64")).browser_download_url'
get_git_pkg "junegunn/fzf" "$f" "/tmp/fzf.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/fzf.tgz"
  rm "/tmp/fzf.tgz"
} || :

f='.[0].assets[]|select(.name|test("linux-amd64")).browser_download_url'
get_git_pkg "jqlang/jq" "$f" "${HOME}/.local/bin/jq" && {
  chmod +x "${HOME}/.local/bin/jq"
} || :

f='.[0].assets[]|select(.name|test("x86_64.*musl")).browser_download_url'
get_git_pkg "casey/just" "$f" "/tmp/just.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/just.tgz" just
  rm -rf /tmp/just.tgz
} || :

f='.[0].assets[]|select(.name|test("_64.*musl.tar.gz$")).browser_download_url'
get_git_pkg "BurntSushi/ripgrep" "$f" "/tmp/ripgrep.tgz" "rg" && {
  tar -C /tmp -xf "/tmp/ripgrep.tgz"
  cp /tmp/ripgrep*/rg "${HOME}/.local/bin/"
  rm -rf /tmp/ripgrep*
} || :

f='.[0].assets[]|select(.name|test("x86_64.*musl")).browser_download_url'
get_git_pkg "ajeetdsouza/zoxide" "$f" "/tmp/zoxide.tgz" && {
  tar -C "${HOME}/.local/bin" -xf "/tmp/zoxide.tgz" zoxide
  rm -rf /tmp/zoxide.tgz
} || :
