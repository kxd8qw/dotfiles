#!/usr/bin/env bash

for i; do
  sed -i 's/[“”]/"/g;s/[‘’]/'"'"'/g;s/[–—]/-/g;s/…/.../g;s/\[/(/g;s/\]/)/g' $i
  grep --color '[^-[:alnum:]$?!#%()/\\*;:+='"'"'"|<>,._ ]' $i || :
done