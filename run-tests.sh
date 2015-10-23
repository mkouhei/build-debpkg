#!/bin/sh -ev

sudo sh -c "echo deb http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse >> /etc/apt/sources.list"
sudo apt-get update -qq
sudo apt-get install -y pbuilder devscripts
sudo apt-get install -y debian-archive-keyring/precise-backports debian-keyring/precise-backports
test ! -f $HOME/base.tgz && sudo pbuilder --create --basetgz $HOME/base.tgz --distribution sid --components main --mirror http://http.debian.net/debian --debootstrapopts "--keyring=/usr/share/keyrings/debian-archive-keyring.gpg"
sudo pbuilder --update --basetgz $HOME/base.tgz

dget http://http.debian.net/debian/pool/main/p/pystache/pystache_0.5.4-5.dsc
sudo pbuilder --build pystache_0.5.4-5.dsc
