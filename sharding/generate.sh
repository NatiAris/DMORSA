#!/bin/bash

rm -rf ./test/
mkdir -p ./test/
cd ./test/
for i in {1..100000}; do
bash ../utils/call.sh
done
