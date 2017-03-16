#!/bin/bash

cd ./data/
mkdir -p sh2-1 sh2-2 sh2-3
mongod --shardsvr --replSet sh2 --dbpath sh2-1 --port 30201 --nojournal --logpath ./logs/sh2-1.log --fork
mongod --shardsvr --replSet sh2 --dbpath sh2-2 --port 30202 --nojournal --logpath ./logs/sh2-2.log --fork
mongod --shardsvr --replSet sh2 --dbpath sh2-3 --port 30203 --nojournal --logpath ./logs/sh2-3.log --fork
