# Written by Mikova Valentina
#Generating of a conference through the server between phone numbers 10, 11, 20 not belonging to the same 
#account.
#The conference occurred during the second day from the present time.

mkdir -p conf48_2ac
date=$(date +%s)
let "date=date*1000"
from_=20
to_=10
t=169200000

let "date=date-t"

echo "{
\"request_type\" :\"create_session\",
\"session_type\" :\"conference\",
\"from_\" :\"$from_\",
\"to_\" :\"$to_\",
\"created\" :{\"\$date\": $date}
}" > conf48_2ac/cs.json

session_id=$(curl -X POST --data @conf48_2ac/cs.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"create_leg\",
\"session_id\" :\"$session_id\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"created\" :{\"\$date\": $date}
}" > conf48_2ac/cl1.json

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$to_\",
\"to_\" :\"-1\",
\"session_id\" :\"$session_id\",
\"created\" :{\"\$date\": $date}
}" > conf48_2ac/cl2.json

leg_id=$(curl -X POST --data @conf48_2ac/cl1.json http://localhost:3467/ --header "Content-Type:application/json")
dt=$(shuf -i 180000-7200000 -n 1)
let "terminated=date+dt"

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf48_2ac/ul1.json

curl -X POST --data @conf48_2ac/ul1.json http://localhost:3467/ --header "Content-Type:application/json"

leg_id=$(curl -X POST --data @conf48_2ac/cl2.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf48_2ac/ul2.json

curl -X POST --data @conf48_2ac/ul2.json http://localhost:3467/ --header "Content-Type:application/json"

datel=$(shuf -i $date-$terminated -n 1)
dt=$(shuf -i 180000-7200000 -n 1)
from_=11
let "terminatedl=datel+dt"
terminatedl=$(($terminatedl>$terminated?$terminated:$terminatedl))

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"session_id\" :\"$session_id\",
\"created\" :{\"\$date\": $datel}
}" > conf48_2ac/cl.json

leg_id=$(curl -X POST --data @conf48_2ac/cl.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminatedl}
}" > conf48_2ac/ul.json

curl -X POST --data @conf48_2ac/ul.json http://localhost:3467/ --header "Content-Type:application/json"




echo "{
\"request_type\" :\"update_session\",
\"session_id\" :\"$session_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf48_2ac/us.json

curl -X POST --data @conf48_2ac/us.json http://localhost:3467/ --header "Content-Type:application/json"