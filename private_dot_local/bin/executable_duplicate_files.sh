#!/usr/bin/env bash
#===============================================================================
#          FILE:  dulicate_files.sh
#
#         USAGE:  ./dulicate_files.sh
#
#   DESCRIPTION:  Find duplicate files in the given path
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: David Personette (david.personette@thomsonreuters.com),
#       COMPANY: Thomson Reuters
#       CREATED: 2012-11-13 10:32:54 EST
#      REVISION: 1.0
#===============================================================================

set -o nounset                              # Treat unset variables as an error

find "${1:-.}" -type f -printf "%p %s\n" | sort -nr -k2 | uniq -D -f1 |
      cut -d' ' -f1 | xargs md5sum | sort | uniq --all-repeated=separate -w32