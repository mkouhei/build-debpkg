#!/bin/sh -ev

sudo sh -c "echo deb http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse >> /etc/apt/sources.list"
sudo sh -c "echo deb http://archive.ubuntu.com/ubuntu wily universe >> /etc/apt/sources.list"
sudo apt-get update -qq
sudo apt-get install -y pbuilder devscripts
sudo apt-get install -y debian-archive-keyring/precise-backports
if [ ! -f $HOME/.gnupg/debian-maintainers.gpg ]; then
    (
        install -d $HOME/.gnupg
        install -d $HOME/tmp
        cd $HOME/tmp
        apt-get download debian-keyring/wily
        ar -x debian-keyring_2015.08.13_all.deb
        tar Jxf data.tar.xz
        install usr/share/keyrings/debian-maintainers.gpg $HOME/.gnupg/
    )
fi
test ! -f $HOME/base.tgz && sudo pbuilder --create --basetgz $HOME/base.tgz --distribution sid --components main --mirror http://http.debian.net/debian --debootstrapopts "--keyring=/usr/share/keyrings/debian-archive-keyring.gpg"
sudo pbuilder --update --basetgz $HOME/base.tgz
dget http://http.debian.net/debian/pool/main/p/pystache/pystache_0.5.4-5.dsc
sudo pbuilder --build pystache_0.5.4-5.dsc
