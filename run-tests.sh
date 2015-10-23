#!/bin/sh -ev

sudo apt-get update -qq
sudo apt-get install -y pbuilder devscripts
test ! -f $HOME/base.tgz && sudo pbuilder --create --basetgz $HOME/base.tgz --distribution sid --components main --mirror http://http.debian.net/debian
sudo pbuilder --update --basetgz $HOME/base.tgz

dget http://http.debian.net/debian/pool/main/p/pystache/pystache_0.5.4-5.dsc
sudo pbuilder --build pystache_0.5.4-5.dsc
