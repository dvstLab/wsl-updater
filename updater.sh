#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2021 rzlamrr

USER='dvst'
PACKAGE_DIR="/mnt/d/Linux" # use /mnt/d instead of D:\
NEW_VERSION=$(curl --silent "https://github.com/nathanchance/WSL2-Linux-Kernel/releases/latest" | sed "s#.*tag/\(.*\)\".*#\1#")

VERFILE="${PACKAGE_DIR}/.version"
CONFIG="/mnt/c/Users/${USER}/.wslconfig"

[[ -f ${VERFILE} ]] && CURRENT_VERSION=$(cat ${VERFILE}) || CURRENT_VERSION="Unknow Version"
[[ -f ~/bzImage ]] && rm ~/bzImage

if [[ "${CURRENT_VERSION}" == "" ]] || [[ "${CURRENT_VERSION}" != "${NEW_VERSION}" ]]; then
    echo "Upgrading from ${PACKAGE_DIR} to ${NEW_VERSION}!"
    [[ -f ${PACKAGE_DIR}/bzImage ]] && mv ${PACKAGE_DIR}/bzImage ${PACKAGE_DIR}/bzImage-old
    curl --silent -L -o ${PACKAGE_DIR}/bzImage "https://github.com/nathanchance/WSL2-Linux-Kernel/releases/download/${NEW_VERSION}/bzImage"
    echo "${NEW_VERSION}" > ${VERFILE}
    echo "${NEW_VERSION} has been installed!"
else
    echo "Kernel is already at latest version ($CURRENT_VERSION)!"
fi

echo '[wsl2]' > ${CONFIG}
echo "kernel = D:\\\\Linux\\\\bzImage" >> ${CONFIG}

echo "To load the new kernel, execute \"wsl.exe --shutdown\" within Windows to terminate the WSL VM."
echo "Afterwards, restart your distro."
