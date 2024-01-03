#!/usr/bin/env -S bash
set -euo pipefail

ignore=$(chezmoi execute-template --with-stdin < \
      "$HOME/.local/share/chezmoi/.chezmoiignore" | grep -v '\*\*')

for i in $(fd . --type directory "$HOME/.local/share/chezmoi"); do
  j="$(sed 's|.*\.local/share/chezmoi/||;s|private_||g;s|dot_|.|g' <<<"${i%/}")"
  for k in $ignore; do grep -Fq "$k" <<<"$j" && continue 2; done
  mkdir -pv "$HOME/$j"
done