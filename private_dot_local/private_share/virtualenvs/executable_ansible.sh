#!/usr/bin/env -S bash

set -euxo pipefail

venv="${HOME}/.local/share/virtualenvs/ansible"

[[ -d "${venv}" ]] || python -m venv "${venv}"

[[ "${VIRTUAL_ENV:-""}" ]] || source "${venv}/bin/activate"

pip install --upgrade pip
pip install --upgrade \
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
      requests
ansible-galaxy collection install --upgrade \
      ansible.posix \
      community.general \
      community.mysql \
      logicmonitor.integration