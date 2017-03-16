#!/bin/bash

mongo --quiet --norc --port 40000 < ./scripts/svr_off.js
for file in ./scripts/*_off.sh
do
  "$file"
done
