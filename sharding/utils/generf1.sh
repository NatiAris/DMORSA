# Written by Mikova Valentina
# Generating get requests for profiling. It takes into account the different frequency of requests.

from_=$(shuf -i 100-999 -n 1)
q=$(shuf -i 0-10000 -n 1)

(( ($q < 66667) && (dt=86400000) )) || 
(( ($q < 89667) && (dt=259200000) )) || 
(( ($q < 96367) && (dt=604800000) )) || 
(( ($q < 99667) && (dt=1209600000) )) || 
(( ($q < 99997) && (dt=2419200000) )) || 
                   ((dt=7257600000))
#24h-3m

echo "{
\$or:[{from_: from_},{to_: from_}],
\"terminated\" :{\$lte: new Date(now)},
\"created\" :{\$gte: new Date(now-$dt)}
}
" > f1.json