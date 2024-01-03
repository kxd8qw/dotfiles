#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

for i in $(find . -name '\.git' -type d | sed 's|^\./||; s|/\.git$||'); do
  echo -e "\n$i:"
  (cd "$i"; git pull || :)
done
