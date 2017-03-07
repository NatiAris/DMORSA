date=$(shuf -i 1450000000000-1489000000000 -n 1)
from_=$(shuf -i 100000-999999 -n 1)
to_=$(shuf -i 100000-999999 -n 1)
i=$(shuf -i 1-8 -n 1)

echo "{
\"request_type\" :\"create_session\",
\"session_type\" :\"conference\",
\"from_\" :\"$from_\",
\"to_\" :\"$to_\",
\"created\" :{\"\$date\": $date}
}" > conf/cs.json

session_id=$(curl -X POST --data @conf/cs.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"session_id\" :\"$session_id\",
\"created\" :{\"\$date\": $date}
}" > conf/cl1.json

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$to_\",
\"to_\" :\"-1\",
\"session_id\" :\"$session_id\",
\"created\" :{\"\$date\": $date}
}" > conf/cl2.json

leg_id=$(curl -X POST --data @conf/cl1.json http://localhost:3467/ --header "Content-Type:application/json")
dt=$(shuf -i 180000-7200000 -n 1)
let "terminated=date+dt"

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf/ul1.json

curl -X POST --data @conf/ul1.json http://localhost:3467/ --header "Content-Type:application/json"

leg_id=$(curl -X POST --data @conf/cl2.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf/ul2.json

curl -X POST --data @conf/ul2.json http://localhost:3467/ --header "Content-Type:application/json"

for (( j=0; j<i; j++ ))
do
datel=$(shuf -i $date-$terminated -n 1)
dt=$(shuf -i 180000-7200000 -n 1)
from_=$(shuf -i 100000-999999 -n 1)

let "terminatedl=datel+dt"
terminatedl=$(($terminatedl>$terminated?$terminated:$terminatedl))

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"session_id\" :\"$session_id\",
\"created\" :{\"\$date\": $datel}
}" > conf/cl.json

leg_id=$(curl -X POST --data @conf/cl.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminatedl}
}" > conf/ul.json

curl -X POST --data @conf/ul.json http://localhost:3467/ --header "Content-Type:application/json"

done





echo "{
\"request_type\" :\"update_session\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf/us.json

curl -X POST --data @conf/us.json http://localhost:3467/ --header "Content-Type:application/json"