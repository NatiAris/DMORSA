#!/bin/bash

cd ./data/
mkdir -p sh4-1 sh4-2 sh4-3
mongod --shardsvr --replSet sh4 --dbpath sh4-1 --port 30401 --nojournal --logpath ./logs/sh4-1.log --fork
mongod --shardsvr --replSet sh4 --dbpath sh4-2 --port 30402 --nojournal --logpath ./logs/sh4-2.log --fork
mongod --shardsvr --replSet sh4 --dbpath sh4-3 --port 30403 --nojournal --logpath ./logs/sh4-3.log --fork
