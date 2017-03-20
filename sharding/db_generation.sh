# Written by Salavat Garifullin
# Generated documents for the DB (by default for 5000 sessions)
# When you call a script, you can specify 3 parameters:
# 1) 'number' - number of required sessions
# 2) -p - enable parallelization in 2 processes
# 3) now - Generates the DB up to this day
# NB: Order is important. If you don't need to use a parameter, you can put null, e.g. "./db_generation.sh 3000 null now"

DIR=$(dirname "${BASH_SOURCE[0]}")

export accounts sessions1 sessions2 legs1 legs2
mkdir -p $DIR/test/
rm $DIR/test/*.json

. $DIR/utils/accounts.sh
echo $accounts > $DIR/test/accounts.json

if [ "-p" == $2 ]; then
	stream2=". $DIR""/utils/stream2.sh $3 &"
	echo3=($(echo $sessions2 >> $DIR/test/sessions.json))
	echo4=($(echo $legs2 >> $DIR/test/sessions.json))
	N=2
else
	N=1
	stream2=:
	echo3=:
	echo4=:
fi

(( ( $[$1] > 0 ) && (n=$[$[$1]/$N]) )) || ((n=$[5000/$N]))

for i in $(eval echo {1..$n}); do
	$stream2
	. $DIR/utils/stream1.sh $3
	echo $sessions1 >> $DIR/test/sessions.json
	echo $legs1 >> $DIR/test/legs.json
	$echo3
	$echo4
done

