#! /bin/bash

# Do not use the default secret
sed -i "s/8e045a51e4b102ea803c06f92841a1fb/$(tr -dc 'a-f0-9' < /dev/urandom | head -c32)/" cms.conf
