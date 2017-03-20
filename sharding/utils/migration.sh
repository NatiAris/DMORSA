# Written by Salavat Garifullin
# Backgrounds process to migrate legacy data

DIR=$(dirname "${BASH_SOURCE[0]}")

border=($($DIR/shard_borders.sh now 24))
sh1=${border[1]}
sh2=${border[2]}
sh3=${border[3]}
sh4=${border[4]}
shkey=0
step=10

for date in $sh1 $sh2 $sh3 $sh4 ; do

# Shard keys this and the next shards
shkey=$[$shkey+1]
next_shkey=$[$shkey+1]

# Counting the required number of operations inside shards
counter="db.legs.find({created: {\$lte: new Date($date)}, shkey: $shkey},{_id:1}).hint({created:1}).count()"
count=$(mongo asl --port 40000 --quiet --norc --eval="$counter")

# Just output to the console
date -d @$[$date/1000]
echo $count

while [ $count -gt 0 ]; do

count=$[$count-$step]

# Search for satisfying IDs
finder="db.legs.find({created: {\$lte: new Date($date)}, shkey: $shkey},{_id:1}).hint({created:1}).limit($step)"
mongo asl --port 40000 --quiet --norc --eval="$finder" > id.json

# Converting received IDs
changer="var change = cat('id.json').slice(10,-2);
var change = change.replace(/ }\n{ \"_id\" : /g, ',');
print(change)"
ID=$(mongo asl --port 40000 --quiet --norc --eval="$changer")

# Extraction of necessary data using the received ID
extractor="db.legs.find({_id:{\$in:[$ID]}},{_id:0})"
mongo asl --port 40000 --quiet --norc --eval="$extractor" > out.json

# Converting data to move to the right shard
corrector="var change = cat('out.json').slice(0,-1);
var change = change.replace(/\"shkey\".{4}/g, '\"shkey\" : $next_shkey');
print(change)"

# Preparing for import and import
mongo asl --port 40000 --quiet --norc --eval="$corrector" > for_import.json
mongoimport --port 40000 --db asl --collection legs --file for_import.json

# Removing old data
remover="db.legs.remove({_id:{\$in:[$ID]}})"
mongo asl --port 40000 --quiet --norc --eval="$remover"

done
done
rm id.json out.json for_import.json
