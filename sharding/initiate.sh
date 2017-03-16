#!/bin/bash

mongo --norc --port 30001 < ./scripts/conf_init.js
mongo --norc --port 30101 < ./scripts/sh1_init.js
mongo --norc --port 30201 < ./scripts/sh2_init.js
mongo --norc --port 30301 < ./scripts/sh3_init.js
mongo --norc --port 30401 < ./scripts/sh4_init.js
mongo --norc --port 30501 < ./scripts/sh5_init.js

mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath ./data/logs/mongos.log

mongo --norc --port 40000 < ./scripts/zones.js
#read -p "Press enter to continue..."
