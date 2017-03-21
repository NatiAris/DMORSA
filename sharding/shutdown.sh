# Written by Salavat Garifullin
# Turns off the cluster

DIR=$(dirname "${BASH_SOURCE[0]}")

mongo admin --quiet --norc --port 40000 --eval="db.shutdownServer()"

n=0
for proc in conf sh1 sh2 sh3 sh4 sh5; do

mongod --dbpath $DIR/data/$proc-1 --port 30$[$n]01 --shutdown
mongod --dbpath $DIR/data/$proc-2 --port 30$[$n]02 --shutdown
mongod --dbpath $DIR/data/$proc-3 --port 30$[$n]03 --shutdown
n=$[$n+1]

done
