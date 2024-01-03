#!/usr/bin/env -S bash
set -euo pipefail
cd "$(dirname "$0")"

git_pull() { local i="$1"
  echo -e "\n$i:"
  (cd "$i"; git pull || :)
}
export -f git_pull

git_paths="$(find . -name '\.git' -type d | sed 's|^\./||; s|/\.git$||' | sort)"

if [[ -x "$(which parallel 2>/dev/null)" ]]; then
  parallel --shell git_pull "{1}" </dev/null ::: ${git_paths}
else
  for i in ${git_paths}; do git_pull "$i"; done
fi