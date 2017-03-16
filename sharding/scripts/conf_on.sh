#!/bin/bash

cd ./data/
mkdir -p conf-1 conf-2 conf-3
mongod --configsvr --replSet conf --dbpath conf-1 --port 30001 --logpath ./logs/conf-1.log --fork --quiet
mongod --configsvr --replSet conf --dbpath conf-2 --port 30002 --logpath ./logs/conf-2.log --fork --quiet
mongod --configsvr --replSet conf --dbpath conf-3 --port 30003 --logpath ./logs/conf-3.log --fork --quiet
