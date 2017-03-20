# Written by Valentina Mikova
# It sends get requests and should create an approximately uniform load on 4 existing shards: 
# 2 days, 2 weeks, 1 month, 4 months.
# Requests from the present time without regard to the borders of shards
# The second way to calculate probabilities for comparison with "reading_load1"

from_=$(shuf -i 100-999 -n 1)
q=$(shuf -i 0-10000 -n 1)
h72=0.75089
w2=0.12515
m1=0.10727
m4=0.01669

b1=$[2*24*3600*1000]	# 2 days
b2=$[14*24*3600*1000]	# 2 weeks
b3=$[30*24*3600*1000]	# 1 month
b4=$[120*24*3600*1000]	# 4 months

h72=$(echo "scale=5;$h72*100000" |bc)
w2=$(echo "scale=5;$h72+$w2*100000" |bc)
m1=$(echo "scale=5;$w2+$m1*100000" |bc)
m4=$(echo "scale=5;$m1+$m4*100000" |bc)

now=$[$(date +%s)*1000]

(( ($q < $h72) && (dt=$(shuf -i 3600000-$b1 -n 1))  )) || 
(( ($q < $w2)  && (dt=$(shuf -i $[$b1+1]-$b2 -n 1)) )) || 
(( ($q < $m1)  && (dt=$(shuf -i $[$b2+1]-$b3 -n 1)) )) || 
(( ($q < $m4)  && (dt=$(shuf -i $[$b3+1]-$b4 -n 1)) ))

echo $q
date -u -d @$[$[$now-$dt]/1000] +%Y-%m-%d:%H:%M:%S
date -u -d @$[$now/1000] +%Y-%m-%d:%H:%M:%S

request='db.legs.find({created:{$gte: new Date('$[$now-$dt]'),$lte: new Date('$[$now]')}},{_id:0,created:1}).hint({created:1}).sort({created:1}).limit(10)'
mongo asl --port 40000 --quiet --norc --eval="$request"