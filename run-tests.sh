#!/bin/sh -ev

apt-get source ${1}/sid
sudo pbuilder --build --basetgz $HOME/base.tgz ${1}_*.dsc
