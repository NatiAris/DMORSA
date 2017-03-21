# Written by Salavat Garifullin
# Intermediate function, for parallelization

export sessions legs

utils=$(dirname "${BASH_SOURCE[0]}")
. $utils/calls.sh $@
sessions2=$sessions
legs1=$legs
