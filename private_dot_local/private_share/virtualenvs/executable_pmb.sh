#!/usr/bin/env -S bash

set -euxo pipefail

venv="${HOME}/.local/share/virtualenvs/pmb"

[[ -d "${venv}" ]] || uv venv "${venv}"

if ! grep -q 'pmbootstrap shutdown' "${venv}/bin/activate"; then
  sed -Ei '/^deactivate \(\)/a \
    # clean up \
    if [ ! "${1:-}" = "nondestructive" ] ; then \
        pmbootstrap shutdown \
        yes | pmbootstrap zap --all \
        sudo rm -rf .local/var/pmbootstrap/* "$VIRTUAL_ENV/pmbootstrap" \
    fi \
' "${venv}/bin/activate"
fi

if ! grep -q 'pmaports' "${venv}/bin/activate"; then
  sed -Ei '/^# The hash/i \
[ -e "$VIRTUAL_ENV/pmbootstrap" ] && rm -rf "$VIRTUAL_ENV/pmbootstrap" \
git clone --depth=1 https://gitlab.postmarketos.org/postmarketOS/pmbootstrap \\\
      "$VIRTUAL_ENV/pmbootstrap" \
yes | \\ln -firs "$VIRTUAL_ENV/pmbootstrap/pmbootstrap.py" \\\
      "$VIRTUAL_ENV/bin/pmbootstrap" \
pmbootstrap init --shallow-initial-clone \
' "${venv}/bin/activate"
fi