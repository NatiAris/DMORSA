#!/bin/bash
cd ./data/
mongod --dbpath conf-1 --port 30001 --shutdown
mongod --dbpath conf-2 --port 30002 --shutdown
mongod --dbpath conf-3 --port 30003 --shutdown
mongod --dbpath sh1-1 --port 30101 --shutdown
mongod --dbpath sh1-2 --port 30102 --shutdown
mongod --dbpath sh1-3 --port 30103 --shutdown
mongod --dbpath sh2-1 --port 30201 --shutdown
mongod --dbpath sh2-2 --port 30202 --shutdown
mongod --dbpath sh2-3 --port 30203 --shutdown

