# Written by Salavat Garifullin

DIR=$(dirname "${BASH_SOURCE[0]}")

n=0
for proc in conf sh1 sh2 sh3 sh4 sh5; do
initiator="rs.initiate({_id:\"$proc\",members:[
{_id:0,host:\"localhost:30"$n"01\"},
{_id:1,host:\"localhost:30"$n"02\"},
{_id:2,host:\"localhost:30"$n"03\"$arbiter}]})"
mongo --port 30$[$n]01 --quiet --norc --eval="$initiator"
arbiter=", arbiterOnly:true"
n=$[$n+1]
done

mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath $DIR/data/logs/mongos.log

declare	-a N=('MinKey' 2 3 4 5 'MaxKey')
for i in {1..5}; do
shards="$shards"'sh.addShard("sh'$i'/localhost:30'$i'01,localhost:30'$i'02"); '
tags="$tags"'sh.addShardTag("sh'$i'", "tag'$i'"); '
range="$range"'sh.addTagRange("asl.legs",{"shkey":'${N[$i-1]}'},{"shkey":'${N[$i]}'},"tag'$i'"); '
done

zones="$shards"'sh.enableSharding("asl");
sh.shardCollection("asl.sessions", {_sid: 1});
sh.shardCollection("asl.legs", {shkey: 1});
*/db.accounts.ensureIndex({_aid: 1}); null;/*
db.sessions.ensureIndex({_sid: 1}); null;
*/db.legs.ensureIndex({_lid: 1}); null;/*
db.legs.ensureIndex({_sid: 1}); null;
db.legs.ensureIndex({created: 1}); null;
sh.disableBalancing("asl.legs");
'"$tags""$range"'sh.enableBalancing("asl.legs"); db.stats()'
#echo $zones > $DIR/test/zones.json
mongo asl --port 40000 --quiet --norc --eval="$zones"
#read -p "Press enter to continue..."
