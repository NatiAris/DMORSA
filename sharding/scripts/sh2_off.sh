#!/bin/bash

mongod --dbpath ./data/sh2-1 --port 30201 --shutdown
mongod --dbpath ./data/sh2-2 --port 30202 --shutdown
mongod --dbpath ./data/sh2-3 --port 30203 --shutdown
