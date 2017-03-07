cd C:\data
rmdir /s /q config-1 config-2 config-3 rs-1-1 rs-1-2 rs-1-3 rs-2-1 rs-2-2 rs-2-3
mkdir config-1 config-2 config-3 rs-1-1 rs-1-2 rs-1-3 rs-2-1 rs-2-2 rs-2-3
start /min mongod --configsvr --replSet conf --dbpath config-1 --port 27001
start /min mongod --configsvr --replSet conf --dbpath config-2 --port 27002
start /min mongod --configsvr --replSet conf --dbpath config-3 --port 27003	
start /min mongod --shardsvr --replSet shard-1 --dbpath rs-1-1 --port 30101 --nojournal
start /min mongod --shardsvr --replSet shard-1 --dbpath rs-1-2 --port 30102 --nojournal
start /min mongod --shardsvr --replSet shard-1 --dbpath rs-1-3 --port 30103 --nojournal
start /min mongod --shardsvr --replSet shard-2 --dbpath rs-2-1 --port 30201 --nojournal
start /min mongod --shardsvr --replSet shard-2 --dbpath rs-2-2 --port 30202 --nojournal
start /min mongod --shardsvr --replSet shard-2 --dbpath rs-2-3 --port 30203 --nojournal
mongo localhost:27001 --eval="quit()"
mongo localhost:27001 < l_conf.js
mongo localhost:30101 < l_shard-1.js
mongo localhost:30201 < l_shard-2.js
pause
start mongos --configdb conf/localhost:27001,localhost:27002,localhost:27003 --port 40000
pause
mongo localhost:40000 < l_mongos.js
pause
start mongo localhost:40000