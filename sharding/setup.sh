#!/bin/bash

./shutdown.sh
./hard_clean.sh
./run.sh
./initiate.sh

while true; do
    read -p "Generate the database?" yn
    case $yn in
        [Yy]* ) ./geterate.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
./import.sh
#mongo --norc --port 40000 < ./cluster/status.js
