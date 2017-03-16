#!/bin/bash

mongod --dbpath ./data/conf-1 --port 30001 --shutdown
mongod --dbpath ./data/conf-2 --port 30002 --shutdown
mongod --dbpath ./data/conf-3 --port 30003 --shutdown
