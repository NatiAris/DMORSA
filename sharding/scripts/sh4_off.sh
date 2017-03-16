#!/bin/bash

mongod --dbpath ./data/sh4-1 --port 30401 --shutdown
mongod --dbpath ./data/sh4-2 --port 30402 --shutdown
mongod --dbpath ./data/sh4-3 --port 30403 --shutdown
