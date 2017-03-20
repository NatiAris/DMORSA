# Written by Salavat Garifullin

DIR=$(dirname "${BASH_SOURCE[0]}")

svr="configsvr"
n=0
for proc in conf sh1 sh2 sh3 sh4 sh5; do

for i in 1 2 3; do
mkdir -p $DIR/data/$proc-$i
mongod --$svr --replSet $proc --dbpath $DIR/data/$proc-$i --port 30$[$n]0$i --logpath $DIR/data/logs/$proc-$i.log --fork --quiet
done
svr="shardsvr"
n=$[$n+1]

done

