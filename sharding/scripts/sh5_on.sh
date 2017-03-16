#!/bin/bash

cd ./data/
mkdir -p sh5-1 sh5-2 sh5-3
mongod --shardsvr --replSet sh5 --dbpath sh5-1 --port 30501 --nojournal --logpath ./logs/sh5-1.log --fork
mongod --shardsvr --replSet sh5 --dbpath sh5-2 --port 30502 --nojournal --logpath ./logs/sh5-2.log --fork
mongod --shardsvr --replSet sh5 --dbpath sh5-3 --port 30503 --nojournal --logpath ./logs/sh5-3.log --fork
