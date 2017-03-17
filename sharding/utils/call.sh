# Written by Mikova Valentina and Akchurin Roman
#Generating of a call for profiling. Possible date of the call is 1.03.2016-1.04.2017.
#Possible phone numbers are 100-999. There are 5 shards. 
#Shard borders from the 1st April 2017: 2 days, 2 weeks, 1 month, 4 months.

_sid1=$(shuf -i 100000000000-999999999999 -n 1)
_sid2=$(shuf -i 100000000000-999999999999 -n 1)
_lid1=$(shuf -i 100000000000-999999999999 -n 1)
_lid2=$(shuf -i 100000000000-999999999999 -n 1)
let "d2=2*24*3600*1000"
let "w2=14*24*3600*1000"
let "m1=30*24*3600*1000"
let "m4=120*24*3600*1000"
now=1490994000000 # around 1st April 2017

let "sh1=now-d2"
let "sh2=now-w2"
let "sh3=now-m1"
let "sh4=now-m4"

date=$(shuf -i 1456779600000-1490994000000 -n 1)
from_=$(shuf -i 100-999 -n 1)
to_=$(shuf -i 100-999 -n 1)
dt=$(shuf -i 5000-7200000 -n 1)
let "terminated=date+dt"
delta=604800000 # lag before update
let "date_ul=terminated+delta"
date_update=$(shuf -i $terminated-$date_ul -n 1)


(( ($date > $sh1) && (shkey=1) )) || 
(( ($date > $sh2) && (shkey=2) )) || 
(( ($date > $sh3) && (shkey=3) )) || 
(( ($date > $sh4) && (shkey=4) )) || 
                    ((shkey=5))

# for debug
# echo $shkey >> temp.temp
# echo $date >> date.temp

echo "{
\"_sid\" :{\"\$oid\": \"$_sid1$_sid2\"},
\"session_type\" :\"call\",
\"created\" :{\"\$date\": $date},
\"updated\" :{\"\$date\": $date_update},
\"from_\" :$from_,
\"to_\" :$to_,
\"terminated\" :{\"\$date\": $terminated}
}

" >> sessions.json

echo "{
\"_lid\" :{\"\$oid\": \"$_lid1$_lid2\"},
\"created\" :{\"\$date\": $date},
\"updated\" :{\"\$date\": $date_update},
\"from_\" :$from_,
\"to_\" :-1,
\"shkey\" :$shkey,
\"terminated\" :{\"\$date\": $terminated},
\"_sid\" :{\"\$oid\": \"$_sid1$_sid2\"}
}" >> legs.json

_lid1=$(shuf -i 100000000000-999999999999 -n 1)
_lid2=$(shuf -i 100000000000-999999999999 -n 1)

echo "{
\"_lid\" :{\"\$oid\": \"$_lid1$_lid2\"},
\"created\" :{\"\$date\": $date},
\"updated\" :{\"\$date\": $date_update},
\"from_\" :-1,
\"to_\" :$to_,
\"shkey\" :$shkey,
\"terminated\" :{\"\$date\": $terminated},
\"_sid\" :{\"\$oid\": \"$_sid1$_sid2\"}
}

">> legs.json
