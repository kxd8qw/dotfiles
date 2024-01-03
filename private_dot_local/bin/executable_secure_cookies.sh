#!/usr/bin/env bash

killall firefox
find $HOME/.mozilla/ -name "*.sqlite" -exec sqlite3 {} "vacuum; analyze;" \;
find $HOME/.mozilla/ -name "cookies.sqlite" -exec sqlite3 {} \
      "update moz_cookies set isSecure = 1;" \;