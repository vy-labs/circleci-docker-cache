#!/bin/bash
VERSION=$(lsb_release -rs)
SKOPEO_LINK=http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_"$VERSION"

VERSION=${VERSION%.*}
CHECKPOINT_VERSION=22
if [[ $VERSION -lt $CHECKPOINT_VERSION ]]; then
        echo "deb ${SKOPEO_LINK}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
        curl -fsSL "${SKOPEO_LINK}/Release.key" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/devel_kubic_libcontainers_stable.gpg > /dev/null
fi

sudo apt-get update
sudo apt-get install skopeo
