# Written by Mikova Valentina, Akchurin Roman and Salavat Garifullin
#Generating of a call for the one year for profiling.
#Possible phone numbers are 100-999. There are 5 shards. 
#Default shard borders from the 1st April 2017: 2 days, 2 weeks, 1 month, 4 months.

utils=$(dirname "${BASH_SOURCE[0]}")

#At start you can put option "now", it will be handed over to the program shard_borders.sh
border=($($utils/shard_borders.sh $@))
now=${border[0]}
sh1=${border[1]}
sh2=${border[2]}
sh3=${border[3]}
sh4=${border[4]}

year_ago=$[$now-370*24*3600*1000]
date=$(shuf -i $year_ago-$now -n 1)
from_=$(shuf -i 100-999 -n 1)
to_=$(shuf -i 100-999 -n 1)
dt=$(shuf -i 5000-7200000 -n 1)
terminated=$[$date+$dt]
delta=604800000 # lag before update
date_ul=$[$terminated+$delta]
date_update=$(shuf -i $terminated-$date_ul -n 1)


(( ($date > $sh1) && (shkey=1) )) || 
(( ($date > $sh2) && (shkey=2) )) || 
(( ($date > $sh3) && (shkey=3) )) || 
(( ($date > $sh4) && (shkey=4) )) || 
                    ((shkey=5))

# for debug
# echo $shkey >> temp.temp
# echo $date >> date.temp

_sid1=$(shuf -i 100000000000-999999999999 -n 1)
_sid2=$(shuf -i 100000000000-999999999999 -n 1)
_lid1=$(shuf -i 100000000000-999999999999 -n 1)
_lid2=$(shuf -i 100000000000-999999999999 -n 1)
_lid3=$(shuf -i 100000000000-999999999999 -n 1)
_lid4=$(shuf -i 100000000000-999999999999 -n 1)

sessions="{
\"_sid\" :{\"\$oid\": \"$_sid1$_sid2\"},
\"session_type\" :\"call\",
\"created\" :{\"\$date\": $date},
\"updated\" :{\"\$date\": $date_update},
\"from_\" :$from_,
\"to_\" :$to_,
\"terminated\" :{\"\$date\": $terminated}
}"

legs="{
\"_lid\" :{\"\$oid\": \"$_lid1$_lid2\"},
\"created\" :{\"\$date\": $date},
\"updated\" :{\"\$date\": $date_update},
\"from_\" :$from_,
\"to_\" :-1,
\"shkey\" :$shkey,
\"terminated\" :{\"\$date\": $terminated},
\"_sid\" :{\"\$oid\": \"$_sid1$_sid2\"}
}
{
\"_lid\" :{\"\$oid\": \"$_lid3$_lid4\"},
\"created\" :{\"\$date\": $date},
\"updated\" :{\"\$date\": $date_update},
\"from_\" :-1,
\"to_\" :$to_,
\"shkey\" :$shkey,
\"terminated\" :{\"\$date\": $terminated},
\"_sid\" :{\"\$oid\": \"$_sid1$_sid2\"}
}"
