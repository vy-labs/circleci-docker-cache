#!/bin/bash
SKOPEO_LINK=http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_"$(lsb_release -rs)"

sudo sh -c "echo 'deb ${SKOPEO_LINK}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
curl -L "${SKOPEO_LINK}"/Release.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install skopeo
