# Written by Salavat Garifullin
# When you call a script, you can specify the parameters:
# -g - generate DB, like "./setup.sh gen"
# -g 'number' - number of required sessions, like "./setup.sh -g 30"
# -i - if only import is enough, like "./setup.sh -i"

DIR=$(dirname "${BASH_SOURCE[0]}")

$DIR/shutdown.sh
$DIR/hard_clean.sh
$DIR/run.sh
$DIR/initiate.sh

if [ "-i" == "$1" ]; then
	$DIR/db_generation.sh -n $2
	$DIR/import.sh
elif [ "-g" == "$1" ]; then
	$DIR/import.sh
fi
