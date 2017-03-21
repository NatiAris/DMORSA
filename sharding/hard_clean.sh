# Written by Salavat Garifullin
# Completely removes the entire cluster (should be disabled)
DIR=$(dirname "${BASH_SOURCE[0]}")

rm -rf $DIR/data/
mkdir -p $DIR/data/logs/

