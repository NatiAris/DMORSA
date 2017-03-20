# Written by Mikova Valentina and Salavat Garifullin
# Generating get requests for profiling. It takes into account the different frequency of requests.

from_=$(shuf -i 100-999 -n 1)
q=$(shuf -i 0-10000 -n 1)
now=$[$(date +%s)*1000]

(( ($q < 6666) && (dt=86400000) )) || 
(( ($q < 8966) && (dt=259200000) )) || 
(( ($q < 9636) && (dt=604800000) )) || 
(( ($q < 9966) && (dt=1209600000) )) || 
(( ($q < 9999) && (dt=2419200000) )) || 
                 ((dt=7257600000))
#24h-3m
echo $q
date -u -d @$[$[$now-$dt]/1000]
date -u -d @$[$now/1000]

request='db.legs.find({created:{$gte: new Date('$[$now-$dt]'),$lte: new Date('$[$now]')}},{_id:0,created:1}).hint({created:1}).sort({created:1}).limit(10)'
mongo asl --port 40000 --quiet --norc --eval="$request"
