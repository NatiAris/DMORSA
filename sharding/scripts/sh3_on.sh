#!/bin/bash

cd ./data/
mkdir -p sh3-1 sh3-2 sh3-3
mongod --shardsvr --replSet sh3 --dbpath sh3-1 --port 30301 --nojournal --logpath ./logs/sh3-1.log --fork
mongod --shardsvr --replSet sh3 --dbpath sh3-2 --port 30302 --nojournal --logpath ./logs/sh3-2.log --fork
mongod --shardsvr --replSet sh3 --dbpath sh3-3 --port 30303 --nojournal --logpath ./logs/sh3-3.log --fork
