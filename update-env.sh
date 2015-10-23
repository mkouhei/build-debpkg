#!/bin/sh -ev

test -z $1 && exit 1

url=$1

pkglist() {
    curl -s $1 | jq -r '.deb[] | select(.Source != null).Source'
}

cat <<EOF > ./.travis.yml
language: python
sudo: true
before_install: ./before_install.sh
env:
EOF

for i in $(pkglist $url)
do
    echo "  - ENV_NAME=$i" >> ./.travis.yml
done

cat <<EOF >> ./.travis.yml
script:
    ./run-tests.sh \$ENV_NAME
EOF
