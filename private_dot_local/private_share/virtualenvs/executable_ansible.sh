#!/usr/bin/env -S bash
set -euxo pipefail

# Where to store the python venv
venv="${HOME}/.local/share/virtualenvs/ansible"

[[ -d "${venv}" ]] || uv venv "${venv}"

[[ "${VIRTUAL_ENV:-""}" ]] || source "${venv}/bin/activate"

uv pip install --upgrade \
      ansible-builder \
      'ansible-core<2.17' \
      ansible-lint \
      ansible-navigator \
      dnspython \
      jinja-cli \
      ldap3 \
      pyOpenSSL \
      PySocks \
      python-dateutil \
      requests \
      resolvelib
uv pip list --exclude ansible-core --exclude resolvelib --outdated |
      awk "\$2~/[0-9]/ {print \$1}" |
      xargs -r uv pip install --upgrade
ansible-galaxy collection install --upgrade \
      ansible.posix \
      community.general \
      community.mysql \
      logicmonitor.integration \
      theforeman.foreman