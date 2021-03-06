# Written by Salavat Garifullin
# Restarts the cluster without reinstalling it

DIR=$(dirname "${BASH_SOURCE[0]}")

$DIR/shutdown.sh
$DIR/run.sh

mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath $DIR/data/logs/mongos.log
