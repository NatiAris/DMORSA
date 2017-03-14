#!/bin/bash

cd ./data/
mongod --configsvr --replSet conf --dbpath conf-1 --port 30001 --logpath ./logs/conf-1.log --fork
mongod --configsvr --replSet conf --dbpath conf-2 --port 30002 --logpath ./logs/conf-2.log --fork
mongod --configsvr --replSet conf --dbpath conf-3 --port 30003 --logpath ./logs/conf-3.log --fork
mongod --shardsvr --replSet sh1 --dbpath sh1-1 --port 30101 --nojournal --logpath ./logs/sh1-1.log --fork
mongod --shardsvr --replSet sh1 --dbpath sh1-2 --port 30102 --nojournal --logpath ./logs/sh1-2.log --fork
mongod --shardsvr --replSet sh1 --dbpath sh1-3 --port 30103 --nojournal --logpath ./logs/sh1-3.log --fork
mongod --shardsvr --replSet sh2 --dbpath sh2-1 --port 30201 --nojournal --logpath ./logs/sh2-1.log --fork
mongod --shardsvr --replSet sh2 --dbpath sh2-2 --port 30202 --nojournal --logpath ./logs/sh2-2.log --fork
mongod --shardsvr --replSet sh2 --dbpath sh2-3 --port 30203 --nojournal --logpath ./logs/sh2-3.log --fork
