# Written by Valentina Mikova and Salavat Garifullin
# Generating get requests for profiling. It takes into account the different frequency of requests.

from_=$(shuf -i 100-999 -n 1)
q=$(shuf -i 0-10000 -n 1)

h24=0.66667
h72=0.22933
d7=0.066666
d14=0.03333
m1=0.003333
m3=0.000667

h24=$(echo "scale=5;$h24*100000" |bc)
h72=$(echo "scale=5;$h24+$h72*100000" |bc)
d7=$(echo "scale=5;$h72+$d7*100000" |bc)
d14=$(echo "scale=5;$d7+$d14*100000" |bc)
m1=$(echo "scale=5;$d14+$m1*100000" |bc)

now=$[$(date +%s)*1000]

(( ($q < $h24) && (dt=86400000)  )) ||    #24h,72h,7d,14d,1m,4m
(( ($q < $h72) && (dt=259200000) )) || 
(( ($q < $d7)  && (dt=604800000) )) || 
(( ($q < $d14) && (dt=1209600000))) || 
(( ($q < $m1)  && (dt=2592000000))) || 
                  ((dt=10368000000))

echo $q
date -u -d @$[$[$now-$dt]/1000] +%Y-%m-%d:%H:%M:%S
date -u -d @$[$now/1000] +%Y-%m-%d:%H:%M:%S

request='db.legs.find({created:{$gte: new Date('$[$now-$dt]'),$lte: new Date('$[$now]')}},{_id:0,created:1}).hint({created:1}).sort({created:1}).limit(10)'
mongo asl --port 40000 --quiet --norc --eval="$request"
