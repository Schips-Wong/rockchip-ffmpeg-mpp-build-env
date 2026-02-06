#!/bin/bash

git clone git://github.com/ninja-build/ninja.git
bash <<EOF
cd ninja
./configure.py --bootstrap
cp ninja ~/.local/bin
EOF

sudo apt install python3 python3-pip
pip3 install  --user meson==0.53
