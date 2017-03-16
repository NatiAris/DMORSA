mkdir -p call72_2ac
date=$(date +%s)
let "date=date*1000"
from_=10
to_=20
t=252000000

let "date=date-t"

echo "{
\"request_type\" :\"create_session\",
\"session_type\" :\"call\",
\"from_\" :\"$from_\",
\"to_\" :\"$to_\",
\"created\" :{\"\$date\": $date}
}" > call72_2ac/cs.json

session_id=$(curl -X POST --data @call72_2ac/cs.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"create_leg\",
\"session_id\" :\"$session_id\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"created\" :{\"\$date\": $date}
}" > call72_2ac/cl1.json

echo "{
\"request_type\" :\"create_leg\",
\"session_id\" :\"$session_id\",
\"from_\" :\"$to_\",
\"to_\" :\"-1\",
\"created\" :{\"\$date\": $date}
}" > call72_2ac/cl2.json

leg_id=$(curl -X POST --data @call72_2ac/cl1.json http://localhost:3467/ --header "Content-Type:application/json")
dt=$(shuf -i 5000-7200000 -n 1)
let "terminated=date+dt"

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call72_2ac/ul1.json

curl -X POST --data @call72_2ac/ul1.json http://localhost:3467/ --header "Content-Type:application/json"

leg_id=$(curl -X POST --data @call72_2ac/cl2.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call72_2ac/ul2.json

curl -X POST --data @call72_2ac/ul2.json http://localhost:3467/ --header "Content-Type:application/json"

echo "{
\"request_type\" :\"update_session\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call72_2ac/us.json

curl -X POST --data @call72_2ac/us.json http://localhost:3467/ --header "Content-Type:application/json"