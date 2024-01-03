#!/usr/bin/env -S bash

set -euxo pipefail

venv="${HOME}/.local/share/virtualenvs/pmb"

[[ -d "${venv}" ]] || python -m venv "${venv}"

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
  sed -Ei '/^# Call hash/i \
[ -e "$VIRTUAL_ENV/pmbootstrap" ] && rm -rf "$VIRTUAL_ENV/pmbootstrap" \
git clone --depth=1 https://gitlab.com/postmarketOS/pmbootstrap.git "$VIRTUAL_ENV/pmbootstrap" \
git clone -b master_staging_systemd https://gitlab.com/postmarketOS/pmaports.git "$HOME/.local/var/pmbootstrap/cache_git/pmaports" \
yes | \\ln -firs "$VIRTUAL_ENV/pmbootstrap/pmbootstrap.py" "$VIRTUAL_ENV/bin/pmbootstrap" \
pmbootstrap init \
' "${venv}/bin/activate"
fi