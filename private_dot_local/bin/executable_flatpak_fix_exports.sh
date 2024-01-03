#!/usr/bin/env -S bash
set -euxo pipefail

find /var/lib/flatpak/exports/bin -xtype l -print0 | xargs -0 -r sudo rm

flatpak list --app | awk -F'	' '{
      gsub(/ /, "-", $1); gsub(/Portal-for-/, "", $1);
      gsub(/Google-/, "", $1);
      gsub(/GNU-Image-Manipulation-Program/, "gimp", $1);
      gsub(/Déjà-Dup-Backups/, "deja-dup", $1);
      gsub(/Signal-Desktop/, "signal", $1);
      print "ln -sf "$2" /var/lib/flatpak/exports/bin/"tolower($1)}' | sudo bash
