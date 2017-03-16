#!/bin/bash

mongod --dbpath ./data/sh1-1 --port 30101 --shutdown
mongod --dbpath ./data/sh1-2 --port 30102 --shutdown
mongod --dbpath ./data/sh1-3 --port 30103 --shutdown

