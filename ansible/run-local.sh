#!/usr/bin/env bash
# For testing updates to the playbook

mkdir -p ~/.ssh
chown 700 ~/.ssh
if ! grep localhost ~/.ssh/known_hosts >/dev/null 2>&1; then
    ssh-keyscan localhost >> ~/.ssh/known_hosts
fi
# Generate a key if it doesn't exist, then add it to authorized_keys to allow ssh to localhost
if ! [[ -e ~/.ssh/id_ed25519 ]]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
    cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
    chown 600 ~/.ssh/authorized_keys
fi

set -x
# NOTE: local connection is being flaky for sudo tasks
#sudo ansible-playbook -c local -i localhost, "$@"
#ansible-playbook --user vagrant -i localhost, -e ansible_ssh_pass=vagrant --skip-tags=packer "$@"
ansible-playbook --user vagrant -i localhost, --skip-tags=packer "$@"
