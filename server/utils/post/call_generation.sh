# Written by Mikova Valentina
#Generating of a call through the server. Possible date of the call is 1.03.2016-1.04.2017.
#Possible phone numbers are 100-999.

mkdir -p call
date=$(shuf -i 1456779600000-1490994000000 -n 1)
from_=$(shuf -i 100-999 -n 1)
to_=$(shuf -i 100-999 -n 1)

echo "{
\"request_type\" :\"create_session\",
\"session_type\" :\"call\",
\"from_\" :\"$from_\",
\"to_\" :\"$to_\",
\"created\" :{\"\$date\": $date}
}" > call/cs.json

session_id=$(curl -X POST --data @call/cs.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"session_id\" :\"$session_id\",
\"created\" :{\"\$date\": $date}
}" > call/cl1.json

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"-1\",
\"to_\" :\"$to_\",
\"session_id\" :\"$session_id\",
\"created\" :{\"\$date\": $date}
}" > call/cl2.json

leg_id=$(curl -X POST --data @call/cl1.json http://localhost:3467/ --header "Content-Type:application/json")
dt=$(shuf -i 5000-7200000 -n 1)
let "terminated=date+dt"

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call/ul1.json

curl -X POST --data @call/ul1.json http://localhost:3467/ --header "Content-Type:application/json"

leg_id=$(curl -X POST --data @call/cl2.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call/ul2.json

curl -X POST --data @call/ul2.json http://localhost:3467/ --header "Content-Type:application/json"

echo "{
\"request_type\" :\"update_session\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > call/us.json

curl -X POST --data @call/us.json http://localhost:3467/ --header "Content-Type:application/json"