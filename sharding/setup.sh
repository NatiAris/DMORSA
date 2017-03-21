# Written by Salavat Garifullin
# When you call a script, you can specify the parameters:
# -i - if only import is enough
# -g - generate DB, by defaulе 5000 sessions
# -g 'number' - number of required sessions

DIR=$(dirname "${BASH_SOURCE[0]}")

$DIR/shutdown.sh
$DIR/hard_clean.sh
$DIR/run.sh -j  # to use profiling
$DIR/initiate.sh

if [ "-g" == "$1" ]; then
	$DIR/db_generation.sh null $2
	$DIR/import.sh
elif [ "-i" == "$1" ]; then
	$DIR/import.sh
fi
