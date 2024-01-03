#!/usr/bin/env -S bash
set -euo pipefail
cd "${1:-$(dirname "$0")}"

git_pull() { local i="$1" tmp=$(mktemp)
  (cd "$i"; git pull 2>&1 || :) | grep -v "Already up to date." >"$tmp" || :
  if [[ -s $tmp ]]; then
    echo -e "\n$i:"
    cat "$tmp"
  fi
  rm "$tmp"
}
export -f git_pull

git_paths="$(find . -name '\.git' -type d | sed 's|^\./||; s|/\.git$||' | sort)"

if [[ -x "$(which parallel 2>/dev/null)" ]]; then
  parallel --shell git_pull "{1}" </dev/null ::: ${git_paths}
else
  for i in ${git_paths}; do git_pull "$i"; done
fi