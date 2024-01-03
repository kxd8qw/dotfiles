#!/usr/bin/env bash
#===============================================================================
#          FILE: git-diff-view.sh
#
#         USAGE: ./git-diff-view.sh
#
#   DESCRIPTION: pretty view of git diffs
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: David Personette (dperson@gmail.com),
#  ORGANIZATION:
#       CREATED: 2015-09-28 12:47
#      REVISION: ---
#===============================================================================

set -euo pipefail                           # Treat unset variables as an error

## Print a horizontal rule
hrule() { printf "%$(tput cols)s\n" | tr " " "-"; }

# Actually strips the leading symbols
strip_diff_leading_symbols() {
  local color_code_regex="(\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K])"

  # Simplify the unified patch diff header
  sed -r "s/^($color_code_regex)diff --git .*$//g; \
        s/^($color_code_regex)index .*$/\n\1$(hrule)/g; \
        s/^($color_code_regex)\+\+\+(.*)$/\1+++\5\n\1$(hrule)\x1B\[m/g; \
        s/^($color_code_regex)[\+\-]/\1 /g"
}

export -f hrule strip_diff_leading_symbols

diff-highlight | strip_diff_leading_symbols | less -r