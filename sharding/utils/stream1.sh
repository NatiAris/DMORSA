# Written by Salavat Garifullin
# When you call a script, you can specify the parameters:

export sessions legs

utils=$(dirname "${BASH_SOURCE[0]}")
. $utils/calls.sh $@
sessions1=$sessions
legs1=$legs
