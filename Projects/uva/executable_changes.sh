#!/usr/bin/env -S bash
set -euo pipefail
cd "${1:-$(dirname "$0")}"

git_status() { local i="$1" tmp=$(mktemp)
  (cd "$i"; git status --show-stash -s 2>&1 &&
        git log --branches --not --remotes 2>&1 || :) >"$tmp"
  if [[ -s $tmp ]]; then
    echo -e "\n$i:"
    cat "$tmp"
  fi
  rm "$tmp"
}
export -f git_status

git_paths="$(find . -name '\.git' -type d | sed 's|^\./||; s|/\.git$||' | sort)"

if [[ -x "$(which parallel 2>/dev/null)" ]]; then
  parallel --shell git_status "{1}" </dev/null ::: ${git_paths}
else
  for i in ${git_paths}; do git_status "$i"; done
fi