#!/usr/bin/env -S bash
#===============================================================================
#          FILE: github-projects.sh
#
#         USAGE: ./github-projects.sh
#
#   DESCRIPTION: Displays status of github projects issues and pull requests
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: David Personette (dperson@gmail.com)
#  ORGANIZATION:
#       CREATED: 2016-05-09 10:41
#      REVISION: ---
#===============================================================================

set -euo pipefail                           # Treat unset variables as an error

site='https://github.com'
user=dperson

echo 'Checking for open or unassigned items...'
for i in $(curl -LSfs "${site}"'/'"${user}"'?tab=repositories' |
      awk -F'"' '/codeRepository/ {print $2}' | sort); do
  curl -LSfs "${site}${i}/issues" | awk -F'"' \
        '$2 ~ /'"$(sed 's|/|\\/|g' <<<"$i")"'\/issues\/[0-9]+/ \
        {print "OPEN: '"${site}"'"$2}' || :
  curl -LSfs "${site}${i}/pulls" | awk -F'"' \
        '$2 ~ /'"$(sed 's|/|\\/|g' <<<"$i")"'\/pull\/[0-9]+/ \
        {print "OPEN: '"${site}"'"$2}' || :
  curl -LSfs "${site}${i}"'/issues?q=is%3Aissue' | awk -F'"' 'BEGIN {uri=""} \
        /@dperson/ {uri=""} $10~/\/issues\/[0-9]+/ \
        {if(uri != "") {print "UNASSIGNED: '"$site"'"uri}; uri=$10}' ||:
  curl -LSfs "${site}${i}"'/pulls?q=is%3Apr' | awk -F'"' 'BEGIN {uri=""} \
        /@dperson/ {uri=""} $10~/\/pull\/[0-9]+/ \
        {if(uri != "") {print "UNASSIGNED: '"$site"'"uri}; uri=$10}' ||:
done