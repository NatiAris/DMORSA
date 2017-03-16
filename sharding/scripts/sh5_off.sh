#!/bin/bash

mongod --dbpath ./data/sh5-1 --port 30501 --shutdown
mongod --dbpath ./data/sh5-2 --port 30502 --shutdown
mongod --dbpath ./data/sh5-3 --port 30503 --shutdown
