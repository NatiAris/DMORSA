# Written by Mikova Valentina
#Generating of a conference through the server. Possible date of the call is 1.03.2016-1.04.2017.
#Possible phone numbers are 100-999.

mkdir -p conf
date=$(shuf -i 1456779600000-1490994000000 -n 1)
from_=$(shuf -i 100-999 -n 1)
to_=$(shuf -i 100-999 -n 1)
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
\"created\" :{\"\$date\": $date}
}" > conf/cl1.json

echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"-1\",
\"to_\" :\"$to_\",
\"created\" :{\"\$date\": $date}
}" > conf/cl2.json

leg_id=$(curl -X POST --data @conf/cl1.json http://localhost:3467/ --header "Content-Type:application/json")
dt=$(shuf -i 180000-7200000 -n 1)
let "terminated=date+dt"

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf/ul1.json

curl -X POST --data @conf/ul1.json http://localhost:3467/ --header "Content-Type:application/json"

leg_id=$(curl -X POST --data @conf/cl2.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
\"terminated\" :{\"\$date\": $terminated}
}" > conf/ul2.json

curl -X POST --data @conf/ul2.json http://localhost:3467/ --header "Content-Type:application/json"

switch=$(shuf -i 0-1 -n 1)

for (( j=0; j<i; j++ ))
do
datel=$(shuf -i $date-$terminated -n 1)
dt=$(shuf -i 180000-7200000 -n 1)
from_=$(shuf -i 100000-999999 -n 1)

switch=$(shuf -i 0-1 -n 1)
let "terminatedl=datel+dt"
terminatedl=$(($terminatedl>$terminated?$terminated:$terminatedl))

if ["$switch" -eq "0"]
then
echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$from_\",
\"to_\" :\"-1\",
\"created\" :{\"\$date\": $datel}
}" > conf/cl.json
fi

if ["$switch" -eq "1"]
then
echo "{
\"request_type\" :\"create_leg\",
\"from_\" :\"$-1\",
\"to_\" :\"$from_\",
\"created\" :{\"\$date\": $datel}
}" > conf/cl.json
fi

leg_id=$(curl -X POST --data @conf/cl.json http://localhost:3467/ --header "Content-Type:application/json")

echo "{
\"request_type\" :\"update_leg\",
\"leg_id\" :\"$leg_id\",
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