#!/bin/bash -eux

# Red Hat / CentOS / Fedora
if [[ -x /usr/bin/yum ]]; then
    yum -y install ansible
fi

# Debian / Ubuntu
if [[ -x /usr/bin/apt ]]; then
    # Install Ansible repository.
    apt -y update && apt-get -y upgrade
    apt -y install software-properties-common
    apt-add-repository ppa:ansible/ansible

    # Install Ansible.
    apt -y update
    apt -y install ansible
fi

# Set up staging directory
if [[ "${ANSIBLE_STAGING_DIRECTORY:-}" != "" ]]; then
    mkdir -p ${ANSIBLE_STAGING_DIRECTORY}
    chown vagrant:vagrant ${ANSIBLE_STAGING_DIRECTORY}
    ln -s "${ANSIBLE_STAGING_DIRECTORY}" ~/ansible
fi
