#!/usr/bin/env bash
url="https://mail.google.com/mail?view=cm&tf=0&to="
firefox -remote "openurl(${url}${1/mailto:/},new-tab)"