#!/bin/bash

mongod --dbpath ./data/sh3-1 --port 30301 --shutdown
mongod --dbpath ./data/sh3-2 --port 30302 --shutdown
mongod --dbpath ./data/sh3-3 --port 30303 --shutdown
