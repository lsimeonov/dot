#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# force?
if [[ "${1}" = "-f" || "${1}" = "--force" ]]; then
    F="yes"
else
    F=""
fi

# question? [Y/n]

Q() {
    echo -ne "${Y}${*} ${B}[y/N]${W} "
    read -n 1 -r
    echo
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# install files in ${HOME}

for z in ${DIR}/.*; do
    baseName=$(basename "${z}")

     [[ ${baseName} =~ ^(.git|.|..)$ ]] && continue
    echo -e "${G}installing${W} ${baseName}"
    if [[ -e ${HOME}/${baseName} ]]; then
        if [[ -n ${F} ]] || Q "File ${HOME}/${baseName} already exists. Overwrite?"; then
            echo -e "Overriding ${HOME}/${baseName} with symlink to ${z}"
            rm -rf ${HOME}/${baseName}
        else
            echo -e "${R}skip${W} ${baseName}"
            continue
        fi
    fi

    ln -sf ${z} ${HOME}/${baseName}
done