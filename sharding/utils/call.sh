mkdir -p call

let "twod=2*24*3600*1000"
let "onew=7*24*3600*1000"
let "treew=21*24*3600*1000"
let "twom=60*24*3600*1000"
now=1490994000000

let "sh1=now-twod"
let "sh2=sh1-onew"
let "sh3=sh2-treew"
let "sh4=sh3-twom"

date=$(shuf -i 1456779600000-1490994000000 -n 1)
from_=$(shuf -i 1000-9999 -n 1)
to_=$(shuf -i 1000-9999 -n 1)
dt=$(shuf -i 5000-7200000 -n 1)
let "terminated=date+dt"
delta=604800000
let "date_ul=terminated+delta"
date_update=$(shuf -i $terminated-$date_ul -n 1)


(($date >= $sh1)) && shkey=1 || 
(($date >= $sh2)) && shkey=2 || 
(($date >= $sh3)) && shkey=3 || 
(($date >= $sh4)) && shkey=4 || 
                     shkey=5 


echo "{
\"session_type\" :\"call\",
\"created\" :{\"\$date\": $date},
\"updated\" :{\"\$date\": $date_update},
\"from_\" :$from_,
\"to_\" :$to_,
\"participants\" :[$from_,$to_],
\"shkey\" :$shkey,
\"legs\" :[{\"created\" :{\"\$date\": $date},
            \"from_\" :$from_,
			\"to_\" :-1,
			\"terminated\" :{\"\$date\": $terminated}},
			
		   {\"created\" :{\"\$date\": $date},
			\"from_\" :-1,
			\"to_\" :$to_,
			\"terminated\" :{\"\$date\": $terminated}}],
			
			\"terminated\" :{\"\$date\": $terminated}
}" > call/call.json

mongoimport --db asl --collection sessions --file call/call.json