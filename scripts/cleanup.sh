#!/bin/bash -eux

# Red Hat / CentOS / Fedora
if [[ -x /usr/bin/yum ]]; then
    # Optionally remove Ansible
    if [[ "${REMOVE_ANSIBLE}" = "true" ]]; then
        yum -y remove ansible
    fi
fi

# Debian / Ubuntu
if [[ -x /usr/bin/apt ]]; then
    if [[ "${REMOVE_ANSIBLE}" = "true" ]]; then
        # Uninstall Ansible and remove PPA.
        apt -y remove --purge ansible
        apt-add-repository --remove ppa:ansible/ansible
    fi

    # Apt cleanup.
    purge-old-kernels
    apt-get -y remove dkms
    apt-get -y autoremove --purge
    apt-get -y clean
fi

# Remove temporary files
rm -rf /tmp/*

if [[ "${ZERO_FREE}" = "true" ]]; then
    # Zero out the rest of the free space using dd, then delete the written file.
    echo "Zeroing free space on root (/)"
    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY
    echo "Done zeroing free space"
else
    echo "Skipping zeroing of free space"
fi

echo "Running 'sync' so Packer doesn't quit too early, before the large file is deleted."
sync
