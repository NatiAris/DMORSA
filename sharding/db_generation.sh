# Written by Salavat Garifullin
# Generated documents for the DB (by default for 5000 sessions)
# When you call a script, you can specify the parameters:
# 'number' - number of required sessions, like "./db_generation.sh 30"

DIR=$(dirname "${BASH_SOURCE[0]}")

export accounts sessions legs
mkdir -p $DIR/test/
rm $DIR/test/*.json

(( ( $[$1] > 0 ) && (n=$[$[$1]]) )) || ((n=5000))

for i in $(eval echo {1..$n}); do
	. $DIR/utils/calls.sh
	echo $sessions >> $DIR/test/sessions.json
	echo $legs >> $DIR/test/legs.json
done
. $DIR/utils/accounts.sh
echo $accounts > $DIR/test/accounts.json

