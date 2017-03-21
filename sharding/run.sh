# Written by Salavat Garifullin
# Runs all mongod servers
# To use profiling, you must enable journaling
# When you call a script, you can specify the parameters:
# -j - enable journaling

DIR=$(dirname "${BASH_SOURCE[0]}")

if [ "-j" == $1 ]; then
	j=""
else
	j=" --nojournal"
fi

svr="--configsvr"
n=0
for proc in conf sh1 sh2 sh3 sh4 sh5; do

for i in 1 2 3; do
mkdir -p $DIR/data/$proc-$i
mongod $svr --replSet $proc --dbpath $DIR/data/$proc-$i --port 30$[$n]0$i --logpath $DIR/data/logs/$proc-$i.log --fork --quiet
done
svr="--shardsvr""$j"
n=$[$n+1]

done

