#!/bin/bash
set -o errexit

CFGS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CFG_DEFGRUB=/etc/default/grub
CFG_IWLWIFI=/etc/modprobe.d/iwlwifi.conf

cfg_install () {
    echo "W.I.P"
}

cfg_backup () {
    echo "Backup started"
    if [ -f $CFG_DEFGRUB ]; then
	cp -i $CFG_DEFGRUB $CFGS_DIR$CFG_DEFGRUB
	echo "Copied ${CFG_DEFGRUB} to ${CFGS_DIR}${CFG_DEFGRUB}"
    else
	echo "<?> configuration does not exist"
    fi
}

help_msg () {
    echo -e "This setup script has two purposes-\n"
    echo -e "1) Install: Installs the configuration files"
    echo -e "in this repository to your Linux/GNU system"
    echo -e "Copies any pre-existing configuration to a"
    echo -e "directory passed as second argument\n"
    echo -e "2) Backup: Copies all existing configurations"
    echo -e "on the system into the current working directory\n"
    echo -e "Pass these options as first argument (in lowercase)"
}

case $1 in
    install)
	cfg_install ;;
    
    backup)
	cfg_backup ;;
    
    *)
	help_msg ;;
esac
