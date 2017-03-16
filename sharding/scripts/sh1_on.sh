#!/bin/bash

cd ./data/
mkdir -p sh1-1 sh1-2 sh1-3
mongod --shardsvr --replSet sh1 --dbpath sh1-1 --port 30101 --nojournal --logpath ./logs/sh1-1.log --fork
mongod --shardsvr --replSet sh1 --dbpath sh1-2 --port 30102 --nojournal --logpath ./logs/sh1-2.log --fork
mongod --shardsvr --replSet sh1 --dbpath sh1-3 --port 30103 --nojournal --logpath ./logs/sh1-3.log --fork
