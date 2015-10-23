#!/bin/sh -ev

url=$1

prebuild() {
    sudo sh -c "echo deb http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse >> /etc/apt/sources.list"
    sudo sh -c "echo deb http://archive.ubuntu.com/ubuntu wily universe >> /etc/apt/sources.list"
    sudo sh -c "echo deb-src http://http.debian.net/debian sid main >> /etc/apt/sources.list"
    sudo apt-get update -qq
    sudo apt-get install -y pbuilder devscripts
    sudo apt-get install -y debian-archive-keyring/precise-backports
    sudo apt-get install -y jq/precise-backports    
    sudo apt-get install -y debian-keyring/wily
    sudo pbuilder --create --basetgz $HOME/base.tgz --distribution sid --components main --mirror http://http.debian.net/debian --debootstrapopts "--keyring=/usr/share/keyrings/debian-archive-keyring.gpg"
}

build() {
    apt-get source ${1}/sid
    sudo pbuilder --build --basetgz $HOME/base.tgz ${1}_*.dsc
}

pkglist() {
    curl $1 | jq -r '.deb[] | select(.Source != null).Source'
}

prebuild
for i in $(pkglist $url)
do
    echo
    echo "----- begin build $i -----"
    build $i
    echo "----- finish build $i -----"
    echo
done
