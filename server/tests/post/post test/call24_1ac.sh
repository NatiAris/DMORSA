mkdir -p call24_1ac
date=$(date +%s)
let "date=date*1000"
from_=10
to_=11
t=3540000

let "date=date-t"

echo "{
\"request_type\" :\"create_session\",
\"session_type\" :\"call\",
\"from_\" :\"$from_\",
\"to_\" :\"$to_\",
\"created\" :{\"\$date\": $date}
}" > call24_1ac/cs.json

session_id=$(curl -X POST --data @call24_1ac/cs.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"create_leg\",
\"session_id\" :\"$session_id\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"created\" :{\"\$date\": $date}
}" > call24_1ac/cl1.json

echo "{
\"request_type\" :\"create_leg\",
\"session_id\" :\"$session_id\",
\"from_\" :\"-1\",
\"to_\" :\"$to_\",
\"created\" :{\"\$date\": $date}
}" > call24_1ac/cl2.json

leg_id=$(curl -X POST --data @call24_1ac/cl1.json http://localhost:3467/ --header "Content-Type:application/json")
dt=$(shuf -i 5000-$t -n 1)
let "terminated=date+dt"

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call24_1ac/ul1.json

curl -X POST --data @call24_1ac/ul1.json http://localhost:3467/ --header "Content-Type:application/json"

leg_id=$(curl -X POST --data @call24_1ac/cl2.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call24_1ac/ul2.json

curl -X POST --data @call24_1ac/ul2.json http://localhost:3467/ --header "Content-Type:application/json"

echo "{
\"request_type\" :\"update_session\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call24_1ac/us.json

curl -X POST --data @call24_1ac/us.json http://localhost:3467/ --header "Content-Type:application/json"